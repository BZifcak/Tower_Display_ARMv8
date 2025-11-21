```markdown
# Moving the Tower on Your Pi 🏰✨

An ARMv8 (AArch64) assembly project for Raspberry Pi that demonstrates joystick input, framebuffer graphics, and interactive LED control. The program draws and moves a control dot across an 8×8 LED array, builds a triangular "tower" when the dot reaches the bottom, and cycles through colors on joystick press.

---

## 📖 Project Description

This project implements the **Moving the Tower** assignment:

- The program is written entirely in **assembly** (`tower.s`).
- It links against two support files:
  - `lights.s` → framebuffer and pixel drawing routines
  - `joystick.s` → joystick input routines
- When executed:
  1. A single dot appears at one edge of the LED array.
  2. Moving the joystick moves the dot in the corresponding direction.
  3. The dot cannot move off the LED array boundaries.
  4. When the dot moves off the "bottom row," a **triangle tower** is drawn beneath it:
     - Each row expands symmetrically (3 pixels, 5 pixels, etc.).
  5. Pressing the joystick button cycles the tower’s color:
     - At least three colors are supported (blue, green, white).
     - After ~10 presses, the screen clears and the program exits.

You can run the provided `towerAR` binary to see the expected behavior.

---

## 🛠️ Exported Functions

From `joystick.s`:

```c
int openJoystick(int deviceNum);
void closeJoystick();
int getJoystickValue();
```

From `lights.s`:

```c
void openfb();
void closefb();
uint16_t getColor(int r, int g, int b);
void setPixel(int x, int y, uint16_t color);
```

---

## 📂 File Structure

```
├── tower.s       # Main assembly program
├── lights.s      # Framebuffer routines
├── joystick.s    # Joystick routines
├── Makefile      # Build rules
```

---

## ⚙️ Build Instructions

On Raspberry Pi (ARMv8/AArch64):

```bash
# Assemble and link
make

# Run the program
./tower
```

To clean build artifacts:

```bash
make clean
```

---

## 🎮 Controls

- **Joystick directions** → Move the control dot.
- **Joystick press (click)** → Cycle through colors.
- **After ~10 presses** → Screen clears and program exits.

---

## 🖼️ Example Behavior

- Start: dot appears at edge of LED array.
- Move: joystick moves dot around.
- Bottom row: tower expands symmetrically beneath the dot.
- Press: tower changes color (blue → green → white).
- Exit: after multiple presses, screen clears and program terminates.

---

## 🚀 Notes

- Written in **ARMv8 assembly** for Raspberry Pi.
- Demonstrates low-level interaction with `/dev/fb0` or `/dev/fb1` (framebuffer) and `/dev/input/event0` (joystick).
- Uses system calls (`svc`) directly for I/O.

---

## 📜 License

Educational project for University of Delaware coursework.  
Feel free to fork and experiment!
```

---

This README gives your graders and anyone browsing your repo a clear overview of what the project does, how to build it, and how to interact with it.  

Do you want me to also add a **diagram of the triangle growth pattern** (like ASCII art showing how the tower expands row by row) to make the README more visual?
