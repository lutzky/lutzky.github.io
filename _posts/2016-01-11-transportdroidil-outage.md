---
date: 2016-01-11 18:56:00
layout: post
title: TransportDroidIL Outage
---

<div style="direction: rtl; border: 1px solid black; background-color: #ffc; text-align: center">
לאחר ההודעה באנגלית תבוא הודעה בעברית.
</div>

Hello TransportDroidIL users! I've been made aware of an outage in TransportDroidIL. The error message that shows up is:

```
java.io.IOException: HTTP/1.1 500: Internal Server error
```

The error message means that the server (Egged or MOT) is not responding to the requests TransportDroidIL is sending it. I do not yet understand why this is, but because I've seen a sharp decline in the number of installed users starting in January, I'm assuming that the MOT and/or Egged have changed the way their site works.

I have not been using TransportDroidIL myself for a few years, and haven't been developing it either, so it will take me some time to fix this problem. In the meantime, I highly recommend that you use [Google Maps](https://play.google.com/store/apps/details?id=com.google.android.apps.maps) for public transport information - this is what I've been using myself, and it works very well. In fact, the only reason I developed TransportDroidIL was that, at the time (September 2010), Google Maps did not provide public transport information for Israel.

If you would like to contribute a fix, please send a github pull request. See [TransportDroidIL on Github](https://github.com/lutzky/TransportDroidIL).

<div style="direction: rtl">
שלום, משתמשי TransportDroidIL! נודע לי על תקלה באפליקציה. ההודעה שמופיעה היא:
</div>

```
java.io.IOException: HTTP/1.1 500: Internal Server error
```

<div style="direction: rtl" markdown="1">
 משמעות ההודעה היא שהשרת (אגד או משרד התחבורה) אינו עונה לבקשות אשר TransportDroidIL שולחת אליו. אני עדיין לא יודע מה גורם לכך, אבל מאחר שראיתי ירידה חדה בכמות המשתמשים אצלם מותקנת האפליקציה מאז תחילת ינואר, אני מניח שמשרד התחבורה ו/או אגד שינו את האופן בו פועל האתר שלהם.
 
 אני לא משתמש ב-TransportDroidIL בעצמי מזה מספר שנים, ואני גם לא מפתח את האפליקציה עוד, ולכן יקח לי זמן-מה לתקן את הבעיה. בינתיים, אני ממליץ בחום שתשתמשו באפליקציית [Google Maps](https://play.google.com/store/apps/details?id=com.google.android.apps.maps) כדי לקבל מידע על תחבורה ציבורית - זו האפליקציה בה אני משתמש בעצמי, והיא פועלת היטב. למעשה, הסיבה שפיתחתי את TransportDroidIL מלכתחילה היא שבאותו הזמן (ספטמבר 2010), Google Maps לא סיפקה מידע תחבורה ציבורית עבור ישראל.
 
 אם אתם מעוניינים לתרום תיקון, אנא שלחו Pull Request באתר Github - ראו [TransportDroidIL on Github](https://github.com/lutzky/TransportDroidIL).
 </div>