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
