# One Piece OS

![License: MIT](img.shields.io) 
![Status: In Development](img.shields.io) 
<!-- You can use the badge above to show status visually -->

A minimal, 64-bit learning operating system built from scratch using C and Assembly.

This project is purely for **educational purposes only** and is currently **under active development**. The goal is to learn how operating systems function at a low level, covering concepts like the boot process, memory management, and hardware interaction. The name "One Piece" is used as a personal, motivating identifier inspired by the anime series.

I am also heavily inspired by the work of the late **Terry A. Davis**, the creator of TempleOS, who demonstrated what highly creative, bare-metal OS programming looks like.

<!-- The rest of the README content goes here... -->

## Table of Contents
- [Project Goals](#project-goals)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [License](#license)

## Project Goals

The objective is to implement a highly limited feature set to understand core OS concepts. The current status is:

*   **Boot Process:** *[In Progress]* Implement a bootloader to move from real mode to 64-bit protected mode.
*   **VGA Driver:** *[Planned]* Implement basic screen output (writing text to the buffer).
*   **Interrupt Handling:** *[Planned]* Set up the Interrupt Descriptor Table (IDT) to handle basic hardware interrupts (e.g., keyboard input, timers).
*   **Memory Management:** (Future Goal) Basic heap allocation.
*   **Simple Shell:** (Future Goal) A bare-bones command interpreter.

<!-- ... rest of the file ... -->

## License

This project is licensed under the [MIT License](LICENSE).
