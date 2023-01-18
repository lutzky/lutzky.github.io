---
title: "Newborn parenting software - part 2"
date: 2021-10-05T21:57:09Z
summary: Logging diapers with satisfying clicks
tags: ["software", "life", "hardware"]
categories: ["Newborn parenting software"]
---

<!-- markdownlint-disable MD013 -->

With BabyBuddy now installed and running properly (see [previous post]({{< ref "2021-10-03-software-parenting-1" >}})), and an always-on display showing the latest information, we now got into the swing of using it. We loved the timeline for "what happened while I as sleeping"; we loved the food amount reports; and because we had a consistent "feed, then change, then wait 15 minutes with baby upright to reduce spit-up" system, the display's "time since last change" box was super useful as well. However, as you might imagine, we did _not_ love handling a freshly-re-diapered baby with one hand while using the other to unlock the phone and navigate to the "yes he pooped now" page in a web app.

My first idea was to create voice commands for the Nest Home Mini in the room. However, it's prone to misunderstanding us; you have to enunciate, and even then the speech recognition is mostly tuned to preexisting Google Assistant commands, and tends to guess that we aren't really saying words like "pee" or "poo". Furthermore, the baby might be crying, or worse yet - lightly sleeping, at risk of being woken up by our voice (or the assistant's). What we needed was a button (well, two - one for pee and one for poo).

I had a Raspberry Pi ZeroW lying around [from a previous project]({{< ref "2021-03-14-pitemp" >}}) and decided to use it for this (the small OLED display wasn't used for this project, but I didn't find a good reason to take it off yet; more on that later). With bits I had from a generic "learn electronics" kit (which I bought for the specific purpose of having such bits), I created the user interface: Two buttons, a green LED for "OK", a red LED for "something went wrong"; all tied together by some jumper cables and a mini breadboard. The Raspberry Pi would handle communicating with BabyBuddy's API (over wifi), reading the buttons, and driving the LEDs. The setup was indeed quite similar to PiTemp's with the software written in Go, cross-compiled, and run on startup using systemd.

{{< image src="poobuttons-rpi0w.jpg" caption="PooButtons on Raspberry Pi ZeroW" >}}

One annoying quirk with the Raspberry Pi Zero for this is that it would register phantom button presses; they'd be quite rare, fewer than 5 a day, but that's certainly enough to mess up diaper reporting. I'm not sure if it's something about the particular GPIO pins I used (GPIO24, GPIO22), and disconnecting the OLED display didn't work. I ended up following the old joke:

> How many software engineers does it take to change a lightbulb?
>
> None, it's a hardware problem.
>
> How many hardware engineers does it take to change a lightbulb?
>
> None, they'll fix it in the software drivers.

Specifically it ended up looking something like this (with another goroutine listening on the resulting channel):

```go
const (
  debounceTime = 2 * time.Second
  stableTime   = 100 * time.Millisecond
)

func listenButtons(ch chan<- int) {
  pull := gpio.PullUp
  edge := gpio.FallingEdge
  level := gpio.Low

  for i, pin := range []gpio.PinIO{
    pinButton1,  // GPIO24
    pinButton2,  // GPIO22
  } {
    n := i + 1
    pin := pin

    go func() {
      for {
        time.Sleep(debounceTime)

        if err := pin.In(pull, edge); err != nil {
          log.Fatalf("Failed to set pin to input: %v", err)
        }

        if pin.WaitForEdge(-1) {
          log.Printf("Got edge, waiting %v for stability", stableTime)
          time.Sleep(stableTime)

          if pin.Read() == level {
            log.Print("Signal was stable, counting as press")
            ch <- n
          } else {
            log.Print("Signal did not remain stable, discarding")
          }
        } else {
          log.Print("WaitForEdge returned false, ignoring")
        }
      }
    }()
  }
}
```

It's not ideal, but it seemed to work; certainly seemed like it should be library code, for someone smarter to debug. Indeed, it turns out that the `periph.io` library had a [Debounce function](https://pkg.go.dev/periph.io/x/conn/v3@v3.6.8/gpio/gpioutil#Debounce) to help with this, but at the time it [wasn't implemented at all](https://github.com/periph/conn/issues/5) (and now that I've spent some time on it, it's partially implemented).

Ultimately, the device worked rather well, and the button pushes were quite satisfying, especially after a particularly nasty diaper change (AKA a poonami). However, it did leave a lot to be desired: The cabling was flimsy and patchy (the pins coming from the ribbon were easy to disconnect), and using a Raspberry Pi here was overkill. Indeed, I ended up using that Raspberry Pi (and OLED display) as a [PiKVM](https://pikvm.org/), and using a microcontroller for the diaper change buttons instead. More on that in the next post.
