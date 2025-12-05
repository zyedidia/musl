#!/usr/bin/env awk
#
# This script post processes aarch64 assembly to modify PAC and BTI instructions.
# The aarch64 code is annotates as if PAC with the A key and BTI are enabled, and
# then stripped or modified based on build time detection of compiler flags. Rather,
# than attempt to insert the instructions, its easier to remove/modify after they are
# added. This keeps the awk script and post processing much simpler. Note that we also
# post process to use the hint instructions, as these are backwards compatible with
# older binutils. Also to note, is that *these* PAC and BTI instructions, since they
# are in the hint space also NOP on unsupoprted hardware. So there is no real penalty
# to run a PAC/BTI aware binary on older hardware except for the cost of the NOP.
#
# Variables:
# - aarch64_pac=[0|1|2] - Set this to 0 to disable pac, 1 to use the a key, and 2 to use the b key
# - aarch64_bti=[0|1] - set this to 0 to disable bti, or 1 to enable bti

# Details on PAC and BTI can be found in the manuals:
#     - https://developer.arm.com/documentation/ddi0487/latest
#     - https://github.com/ARM-software/abi-aa/blob/main/pauthabielf64/pauthabielf64.rst
#
# However, the TL;DR is the 3 part blog post that explores the relevant
# parts for software:
#  - https://community.arm.com/arm-community-blogs/b/architectures-and-processors-blog/posts/enabling-pac-and-bti-on-aarch64

BEGIN {
  # Validate aarch64_pac
  if (aarch64_pac !~ /^(0|1|2)$/) {
    print "Error: invalid value for aarch64_pac (" aarch64_pac "). Must be one of: 0, 1, 2." > "/dev/stderr"
    exit 1
  }

  # Validate aarch64_bti
  if (aarch64_bti !~ /^(0|1)$/) {
    print "Error: invalid value for aarch64_bti (" aarch64_bti "). Must be one of: 0, 1." > "/dev/stderr"
    exit 1
  }
}

# Body
# Behavior based on this table
# | case | aarch64_bti | aarch64_pac | action |
# | ---- | ----------- | ----------- | ------ |
# |    1 |           0 |           0 | strip all paciasp, autiasp and bti c or j instructions |
# |    2 |           0 |           a | strip all bti c or j instructions, rewrite pac using hints |
# |    3 |           0 |           b | change paciasp to pacibsp and autiasp to autibsp instructions, using hint, and strip all bti c instructions|
# |    4 |           1 |           0 | change all paciasp to bti c instructions, using hints and strip all autiasp instructions |
# |    5 |           1 |           a | rewrite to hints |
# |    6 |           1 |           b | change paciasp to pacibsp and autiasp to autibsp instructions |
{
# Declare some variables to keep the hint instruction mapping in one spot
  PACIASP = "hint 25"
  AUTIASP = "hint 29"
  PACIBSP = "hint 27"
  AUTIBSP = "hint 31"
  BTI_C = "hint 34"
  BTI_J = "hint 36"

  # case 1 - strip all
  if (aarch64_bti == 0 && aarch64_pac == 0 &&
      /(paciasp|autiasp|bti[[:space:]]+[cj])/) {
      next
  # case 2 - strip bti c
  } else if (aarch64_bti == 0 && aarch64_pac == 1) {
    if (/bti[[:space:]]+[cj]/) {
      next
    }
    gsub(/paciasp/, PACIASP)
    gsub(/autiasp/, AUTIASP)
  # case 3 - swap for b key and strip bti c
  } else if (aarch64_bti == 0 && aarch64_pac == 2) {
    if (/bti[[:space:]]+[cj]/) {
      next
    } else {
      gsub(/paciasp/, PACIBSP)
      gsub(/autiasp/, AUTIBSP)
    }
  # case 4 - remove autiasp and swap paciasp for bti c and rewrite bti j
  } else if (aarch64_bti == 1 && aarch64_pac == 0) {
    if (/autiasp/) {
      next
    } else {
      gsub(/paciasp/, BTI_C)
      gsub(/bti c/, BTI_C)
      gsub(/bti j/, BTI_J)
    }
  # case 5 - rewrite all to hints
  } else if (aarch64_bti == 1 && aarch64_pac == 1) {
    gsub(/paciasp/, PACIASP)
    gsub(/autiasp/, AUTIASP)
    gsub(/bti c/, BTI_C)
    gsub(/bti j/, BTI_J)
  # case 6 - swap for b key
  } else if (aarch64_bti == 1 && aarch64_pac == 2) {
      gsub(/paciasp/, PACIBSP)
      gsub(/autiasp/, AUTIBSP)
      gsub(/bti c/, BTI_C)
      gsub(/bti j/, BTI_J)
  }

  print
}

END {
  # Add the GNU Notes section indicating what the binary supports.
  GNU_PROPERTY_AARCH64_BTI = aarch64_bti
  GNU_PROPERTY_AARCH64_POINTER_AUTH = (aarch64_pac != 0 ? 2 : 0)

  if (aarch64_bti != 0 || aarch64_pac != 0) {
    print "\n\n" \
      ".pushsection .note.gnu.property, \"a\"; /* Start a new allocatable section */\n" \
      ".balign 8; /* align it on a byte boundry */\n" \
      ".long 4; /* size of \"GNU\0\" */\n" \
      ".long 0x10; /* size of descriptor */\n" \
      ".long 0x5; /* NT_GNU_PROPERTY_TYPE_0 */\n" \
      ".asciz \"GNU\";\n" \
      ".long 0xc0000000; /* GNU_PROPERTY_AARCH64_FEATURE_1_AND */\n" \
      ".long 4; /* Four bytes of data */\n" \
      ".long ("GNU_PROPERTY_AARCH64_BTI"|"GNU_PROPERTY_AARCH64_POINTER_AUTH"); /* BTI or PAC is enabled */\n" \
      ".long 0; /* padding for 8 byte alignment */\n" \
      ".popsection; /* end the section */"
  }
}
