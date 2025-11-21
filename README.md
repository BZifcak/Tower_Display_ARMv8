# Tower — Raspberry Pi LED Tower Game (ARM64 Assembly)

This project implements **“Moving the Tower”** for an 8×8 RGB LED matrix using the Raspberry Pi.
The program is written entirely in **ARM64 assembly** and interfaces with two provided modules:

* `lights.s` → framebuffer + `setPixel`
* `joystick.s` → joystick input handler

---

## 🎮 Program Behavior

### 1. **Startup**

* The program initializes the joystick and framebuffer.
* A single **control dot** appears at the top edge of the LED array.
* Default color: **red**.

### 2. **Movement**

Using the joystick:

| Input | Action         |
| ----- | -------------- |
| Up    | Move dot up    |
| Down  | Move dot down  |
| Left  | Move dot left  |
| Right | Move dot right |

The dot is **clamped** to remain inside the 8×8 grid.

### 3. **Drawing the Tower**

When the control dot moves off the **bottom edge**:

* The screen clears.
* A **centered triangle (tower)** is drawn downward, expanding symmetrically:

```
    ●
   ●●●
  ●●●●●
```

* Tower color matches the control dot.

### 4. **Color Cycling**

Pressing the joystick button cycles colors through:

1. Red
2. Blue
3. Green
4. White
   …continuing until **10 presses**, after which:

* Screen clears
* Program exits cleanly

---

## 🗂 File Overview

```
tower.s        → Main program logic
lights.s       → Framebuffer + setPixel
joystick.s     → Joystick driver and event parser
Makefile       → Build instructions
```

---

## 🛠 Build & Run

```bash
make
sudo ./tower
```

---

## 📁 Key Functions (tower.s)

* `_start` — initialization + main loop
* `getJoystickValue` — interprets joystick events
* `.safeDisplay` — bounds check + mapped LED coordinate
* `.drawTower` — draws centered triangle
* `.clear` — clears entire LED matrix

---

## 📷 Demo

Run the instructor's reference program:

```bash
./towerAR
```

---

## 📜 Notes

* Works on `/dev/fb0` or `/dev/fb1` automatically.
* Uses 16-bit RGB565 color via `getColor`.
* Triangle width adapts dynamically based on the dot’s X coordinate.
