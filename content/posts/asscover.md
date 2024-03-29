---
date: "2019-07-12T00:00:00Z"
slug: asscover
aliases: ["/2019/07/12/asscover/"]
summary:  On the importance of blameless postmortem culture, demonstrated via its antithesis.
title: Ass-cover
---

<!-- markdownlint-disable MD013 -->

When presenting [SRE postmortem culture][pm-culture], and the importance of its blamelessness, I always find it useful to present its antithesis. As it's often-claimed that the Eskimo have many words for snow, my home country of Israel has a word for covering one's ass - כסת"ח, pronounced /kastáχ/, an abbreviation of כיסוי תחת. This abbreviation is impressively conjugatable; for example, the term מכוסת"ח roughly corresponds to "appears as though it was made while covering one's ass".  I have it on good authority that the italian term "Paraculo" is closely related.

[pm-culture]: https://landing.google.com/sre/sre-book/chapters/postmortem-culture/

[Ori Katz's blog post](https://orikatz.wordpress.com/2012/06/10/kastac/) provides a wonderful introduction to this concept. I bring this translated version before you as a warning example of the importance of blame-free culture.

Notes in (OL:) are translator's notes. I have attempted to represent the original (Hebrew) post as accurately as possible.

## The translated blog post

One of the common and erroneous beliefs is that the primary business of people responsible for something - be they politicians, military commanders, civilian managers etc. - is managing the thing they're responsible for. This belief is fed by the illusion of control, which has us overestimating the importance of conscious actions of people as reasons for things that happen, and underestimating blind luck and circumstances that are outside the control of those involved.

The truth is that many things happen for no reason, by chance. A commander might make all the correct decisions in battle, but still lose due to an error in judgement by his superiors or subordinates. A businessperson might make the worst possible decisions, and still turn a profit because the entire field of his business has had an impressive profit surge due to an external reason, or because a competitor went bankrupt. A minister can make correct decisions that would only affect the following term of office, and be criticized for decisions made by his predecessor or a global economic crisis outside of their control.

Therefore, in many cases the best managers, politicians and commanders (and anyone else who manages anything) are those who excel at the following task: Make the bad things that happened during their shift look like someone else's fault, as external circumstances outside their control or bad luck, and make the good things that happened during their tenure look like they happened thanks to them. Truly, many of the managers I've met are experts in this matter - the ass-covering ability.

Ass-covering is far more than military slang intending to describe amusing phenomena. Ass-covering is the way a world works when there's uncertainty about people's ability to properly perform their job; when there's no way to accurately measure the output of most people in most professions, especially higher-ranking ones, and it's impossible to separate individual contributions from external influences. Ass-covering is the way our world works.

Many things which seem as though they shouldn't exist in a logical world with rational humans have their roots in ass-covering. For example, recruitment screening agencies.

If there are ten measures of stupidity in the business world, recruitment screening agencies have taken at least eight upon themselves[^talmud]. Upon first exposure to the phenomenon, people are astounded by its scope, the superficiality of the tests and interviews, and the cheap psychology behind the whole matter. The truth is that recruitment screening agencies exist for a very good reason: it's difficult to find good employees. People (especially those who read my post on the matter) don't represent themselves fairly during job interviews, school grades don't accurately predict the required traits for an excellent employee, and ultimately hiring a new employee is always a wager. And once there's uncertainty, ass-covering slithers its way in.

[^talmud]: OL: This is a Talmud reference. Originally: "Ten measures of beauty descended to the world, nine were taken by Jerusalem."

When an HR officer at a certain company needs to hire new people, they can make this wager themselves, or they can send them to one of the recruitment screening agencies. There, the potential employees will pass a variety of tests which, as is known for decades, predict next-to-nothing; they will be asked to draw trees in order to see that they draw pretty and optimistic trees; to fill in blanks such as "the child was sad when ..." (recommended: "when an analyst at the recruitment screening agency decided he wasn't a good fit for the job, and he was forced to kill them"), et cetera. If the candidates turn out to be bad employees, the HR officer can always say "they passed ScreenAgent". It isn't their responsibility.

In his book "Rationality, Fairness, Happiness", economics nobel laureate Daniel Kahneman describes tests he performed decades ago on [IDF][idf] officer's course candidates (it's possible the same tests are being performed today). He and his colleagues gave soldiers various tasks, and observed which soldiers display leadership, which shy away, and so forth. In post-facto checks, Kahneman found that these assessments had very poor predictive abilities for the soldiers' success as officers, but despite him notifying his superiors about this they kept the tests in their present state, and his psychologist friends simply refused to accept the fact that their intuition isn't as strong as they had thought. At the end of the day, IDF recruiters also need ass-covering to avoid being blamed for placing people in roles they are unfit for.

[idf]: https://en.wikipedia.org/wiki/Israel_Defense_Forces

Ass-covering culture is very developed in the IDF, and it explains the variety of useless briefings and debriefings performed for every fool thing, so - heaven forbid - nobody will be able to claim that LCDR[^lcdr] John Doe didn't draw conclusions and respond to the incident. As an amusing example I've come across recently, see the recommendations at the end of the following document:

[^lcdr]: OL: Lieutenant Commander, the 4th rank of officers in naval terminology.

(OL: The following is a best-fit translation of a military debriefing/"postmortem" document. See original below. Its standard format is instantly identifiable to anyone that has ever read an IDF document attempting to look official; this includes the wonky formatting and enumeration of every sentence. "Sunday Culture" is an event held in many units that, during the first day of the week, soldiers are taken to various cultural or entertainment events.)

> **Subject: Assault of a soldier by a peacock during the course of Sunday Culture.**
>
> Battalion HSN, lieutenant commander
>
> 1. **General**
>     1. **Description of the event:** In 11/9/05 the battalion performed Sunday Culture at the Jerusalem Biblical Zoo. During this visit one of the soldiers provoked a peacock displayed at the location, and was attacked by it.
>     2. Involved in the event:
>         - Igal Zaguri (OL: the following is the ID) 72924690
>         - A peacock of the biblical zoo
> 2. **Findings:**
>     1. The soldier Igal Zaguri arrived for a visit at the biblical zoo in Jerusalem during the battalion Sunday Culture.
>     2. During the visit, it was clarified to the soldiers that they should stay away from the animals that roam the zoo freely.
>     3. During a visit to the bird section, the soldier Igal approached one of the peacocks and began provoking it.
>     4. The peacock saw the soldier as a threat, attacked him and injured his leg lightly.\
>        **Additional findings:**
>     5. The peacock is male and saw the provocation as a territorial offense.
>     6. The soldier Igal Zaguri is known as a problematic soldier.
>     7. During the provocation, an additional soldier was present and threw stones at the peacock.
> 3. **Conclusions:**
>     - **Cause:** The attack happened as a response to the soldier's provocation of the animal.
>     - **Things worth preserving:**
>         - Vigilance of the commanders to the event and rapid treatment of the casualty
>     - **Outcome:** A slight injury to the right leg of soldier Igal Zaguri.
> 4. **Lessons learned and recommendations:**
>     1. A safety briefing needs to be performed prior to any military visit to establishments involving contact with animals.
>     2. A lecture needs to be given in the units about contacting animals in the base.
>     3. Soldiers need to understand the problematic nature of provoking peacocks.
>
> **For immediate distribution to all command courses in the IDF**
>
> {{< style "font-family: 'Comic sans', cursive; size: xx-large; font-weight: bold" >}}Daniel Peleg, Sergeant\
MNHIG 75{{< /style >}}[^comic-sans]

[^comic-sans]: OL: For those familiar with the font, the signature was originally in Guttman Yad Brush; the signature is represented in Comic Sans, an appropriate approximation.

---

Translator's note: It turns out that this debriefing is a hoax. A 2005 [news article][hoax-article] states this. After describing the debriefing shortly, the article states:

[hoax-article]: http://www.ynet.co.il/articles/0,7340,L-3161734,00.html

> Sounds convincing? Yes, as it turns out. Many officers and soldiers that received this debriefing via (OL: internal) email were convinced that the event did, in fact, happen. Even the chief armored command stated that they received the email and did not doubt it."
>
> And now the truth: There is no soldier by the name Igal Zaguri in battalion 75, and on September 11th the battalion was in Gaza, preparing for the disengagement. Some in the IDF are not smiling. According to military sources, using military email is not intended for distribution of jokes; furthermore the usage of military topics such as battalion number was frowned upon, and now there are attempts to locate the soldier and possibly court-martial them.

The translator does not believe that this debriefing being fake detracts from the value of this post.

---

Why does this happen? On the one hand, the IDF has a strict hierarchy and the principle of command responsibility, and on the other hand the IDF deals with tasks that are naturally dangerous and likely to have casualties, especially training accidents. Therefore, commanders in the military must ass-cover (OL: לכסת"ח, yes, this is a verb) themselves at a higher intensity than managers in the civilian market.

A similar phenomenon is the growth of consultancy companies, which perform projects of organizational, operative and strategic consulting for large companies. In many cases the purpose of the consultancy company is merely to provide an "objective" approval to a reform a manager wanted to perform anyway, and essentially supply that manager with ass-cover (OL: noun) in case the reform fails ("What? It wasn't me, the consultants said to do this"). I worked in a company like this for almost two years, and for fairness I must state that there were also successful projects where this wasn't their purpose, or cases in which the recommendations contradicted the opinion of management and higher-ups in the consultancy company insisted on professional integrity, but there are many projects which are nothing but part of the ass-cover phenomena. It's just very convenient to pass the buck to some external "expert", blame them in case misfortune occurs, and take credit for hiring them in case fortune occurs. For the same reason politicians, especially in Israel, start committees instead of making decisions. The committees seat a variety of bureaucrats which are easy to blame in case some reform or another fails, and often enough the finger of blame is pointed at the bureaucrats rather than the politicians that appointed them.

There is variance in the depth of ass-cover between organizations, and it might be worth asking what the source of this variance is - can the phenomenon be reduced?

In my opinion, the answer to this question lies in the "concept of failure" among the deciding ranks - in the case of commanders or managers, it is those above them in the hierarchy, and in the case of politicians it's us, the public. In the military, as I wrote, the concept of failure references "command responsibility". If some base sentry does something stupid, the base commander is also responsible for the results. Furthermore, there aren't too many second chances in the military, and one sufficiently-severe mistake can end with dismissal. There is, of course, a good reason for this concept of failure, and it certainly has positive implications, but the ass-cover culture is the negative side of the matter. In other organizations where a manager is expected to be responsible for every little detail, and every manager that makes a mistake is dismissed without a second thought, ass-covering will flourish. Managers will spend more time preventing future blame of themselves, and less time managing the field they're responsible for. For politicians as well, public and media criticism tends to be populistic, which supports ass-cover culture. Sometimes it seems, mainly with the poorer prime ministers we've had, that daily life is dictated by attempts to evade the current media storm and not be decision-making and working towards some policy.

Organizations with weaker ass-covering are ones where it's very obvious who's responsible for what, it's relatively easy to measure results and output, and there is an ongoing effort not to judge solely by post-facto results. Sometimes the managers who made mistakes are actually the ones you want to keep employed, as they will be more careful going forward, but few organizations internalize this truth.

Ass-covering is a basic incentive deep in the heart of the modern world, and can certainly explain a variety of additional phenomena not stated here that at first glance look like absolute stupidity. When attempting to think about why the world is the way it is, one should not be confused and assign imagined motives to people, different from their real ones. Yes, managers also attempt to form a long-term strategy for their company, and many military commanders also make tough choices in stressful situations and take responsibility, and I honestly believe that deep down, most of our politicians are truly interested to drive forward the ideology they believe in. But at the end of the day we all act according to the incentives the system poses against us, and ass-covering is one hell of an incentive.

## Appendix: Related terms

I highly recommend understanding the related term "Sentry Syndrome" (תסמונת הש"ג), explained in the Wikipedia entry for [Night of the Gliders](https://en.wikipedia.org/wiki/Night_of_the_Gliders).

A related slang term to כסת"ח/Kastach/Asscover is בלת"ם/Baltam. It's an abbreviation of בלתי מתוכנן, or "unplanned", but is used as a noun (one Baltam, many Baltamim), representing an unexpected event that throws a wrench in your plans. This is often the result of poor planning, possibly as a result of lack of taking responsibility due to ass-cover. The presence of these within blameful culture also necessitates additional ass-covering, altogether creating the בלת"ם-כסת"ח cycle.
