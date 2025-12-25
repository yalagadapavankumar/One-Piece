## When you press the power button (Elecrical Level)

**ATX PSU Signals**

These signals are defined in the **ATX Power Supply Specification**

**Main PSU signals**

| Signal             | Direction         | Meaning                   |
| ------------------ | ----------------- | ------------------------- |
| `5VSB`             | PSU → Motherboard | Standby power (always on) |
| `PS_ON#`           | Motherboard → PSU | Power-on command          |
| `PWR_OK`           | PSU → Motherboard | Power is stable           |
| `+12V, +5V, +3.3V` | PSU → Motherboard | Main power rails          |
| `GND`              | —                 | Ground                    |

## What happens step-by-step
**Step 1: Plug PSU into wall**
* PSU outputs +5VSB (standby voltage)
* Motherboard logic is partially alive
* Power button circuit works

**Step 2: You press the power button**
* Power button is not directly connected to PSU
* It signals the Super I/O or PCH
* Motherboard logic decides to power on

**Step 3: Motherboard asserts** `PS_ON#`
* PS_ON# is active low
* Motherboard pulls it LOW
* PSU starts main power rails

      PS_ON# = 0 → PSU ON
      PS_ON# = 1 → PSU OFF

**Step 4: PSU ramps up voltages**

* +12V
* +5V
* +3.3V

PSU internally checks:

* Voltage stability
* Overcurrent
* Overvoltage

**Step 5: PSU asserts** `PWR_OK`

* PWR_OK = HIGH (~5V)
* Means power is stable
* CPU is allowed to start execution

If PWR_OK never goes high:

* CPU will not run
* System appears dead

**Step 6: CPU reset is released**

* CPU reset pin deasserted
* CPU starts executing firmware code

**CPU Reset and First Instruction**

on reset:
* CPU enters **Real Mode**
* CS = 0xF000
* IP = 0xFFF0
* Physical address = **0xFFFF0**

That address is hardwired in silicon

That address is **not RAM**.

It maps to **firmware ROM**.

**Why ROM?**

Because at this moment:
* RAM is uninitialized
* Stack does not exist
* No disk driver exists
* No filesystem exists

ROM is:
* always present
* read only
* trusted

So the CPU executed **firmware code first**, always.

**What BIOS/UEFI**

**BIOS (legacy)**
* simple
* 16-bit
* Minimal services
* Very limited

**UEFI (modern)**
* Modular
* 32-bit or 64-bit
* Filesystem aware
* Can load real executables

But conceptually, both exist to do same thing:

    Bring the system from electrical chaos to software control

**Firmware's Core Responsibilities**

Firmware must do these in strict sequence.

**CPU Initialization**
* Load microcode updates
* Configure control registers
* Disable undefined features

Why:
* CPUs ship with bugs
* Microcode patches fix them

if skipped:
* Random crashes
* Silent corruption

**Memory Initialization**

RAM **does not work by default**.

Firmware must:
* Train memory timings
* Configure memory controller
* Detect usable ranges

This is hard **Why?**:
* RAM speeds vary
* Motherboard layouts differ
* Electrical timing is delicate

If memory init fails:
* Nothing else can run
* System halts or reboots

This is why firmware is hardware specific.

**Hardware Enumeration**

Firmware scans buses:
* PCIe
* USB
* SATA
* NVMe

For each device:
* Reads configuration space
* Assings addresses
* Enables functionality

Why OS can't do this first:
* OS is not running yet.
* CPU needs devices configured before disk access

**Why Firmware Exists at allowed**

you might ask:

       Why not boot directly into the OS?
Because:
* OS assumes memory works
* OS assumes disk access
* OS assumes interrupts
* OS assumes a Stack

At power on:
* none of those exist

Firmware is a bridge between:
* physics -> software

**Boot Device Selection**

Firmware now looks for something bootable.

Legacy BIOS
* Reads first 512 bytes of a disk (MBR)
* Jumps to it blindly

Why 512 bytes?
* Old disk sector size
* Historical constraint

Why this is terrible:
* No filesystem
* No validation
* Extremely fragile

**UEFI (Modern)**
* Understands **FAT32**
* Loads `.efi` executables
* Verifies format
* Can verify signatures (Secure Boot)

**UEFI Execution Environment**

When UEFI Loads an EFI program:

the CPU  is already:
* in *64-bit long mode*
* paging enabled
* stack provided
* firmware servcies avilable

This is why modern OSes prefer UEFI.

but beware:

        You do NOT own the machine yet

Firmware still:
* owns interrupts
* owns memory allocations
* owns hardware state

**Firmware Services**

UEFI provides:
* Memory allocation
* Disk I/O
* Graphics output
* Time services

These are **temporary crutches**.

Why temporary:
* Firmware is not an OS
* It is not reentrant
* It is not designed for multitasking

Using firmware services after boot is a **design error**.

**The Critical Moment: Exisiting Firmware**

There is one function that matters more than all others:

        ExitBootServices()
Calling it means:
* Firmware stops managing memory
* Firmware stops handling interrupts
* Firmware steps aside permanently

After this: There is **no safety net**

Why this moment is dangerous:
* Memory map must be correct:
* Paging must be sane
* Stack must exist

if wrong:

* Instant crash
* No error messages
* No recovery

This is where real OSes are born.
