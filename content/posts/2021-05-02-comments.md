---
title: "Code comments"
date: 2021-05-02T11:02:57+01:00
slug: comments
aliases: ["/2021/05/02/comments/"]
tags: ["software"]
---

<!-- markdownlint-disable MD013 -->

Good code comments only describe *why* the code is (or isn't!) doing something. <!--more--> When teaching coding or reviewing code, I sometimes encounter comments describing *what* it's doing, and those are almost always harmful.

To be clear, I'm talking about *code comments*, not *documentation comments*. This nuance is different in every language and setup, but for Go, this is it:

```go
// UsefulFunction does useful things. This is a documentation
// comment, and will be displayed in godoc, IDE autocomplete,
// and more.
func UsefulFunction() {
    // this and all of the below are code comments

    // count visitors //
    // x is the visitor counter
    x := 0
    x++ // increment x
}
```

## Document "why" {#why}

In some code, things are done for non-intuitive reasons. It's worth pointing that out - it makes your code easier to read for a newcomer trying to understand why it's written that way. In this example, technically `sumOfIntsWithThreshold` will work absolutely correctly without its input being sorted, but it [turns out that it will be faster if it is][sorted-is-faster].

[sorted-is-faster]: https://stackoverflow.com/questions/11227809

```go
sort.Ints(a) // improves performance; see https://stackoverflow.com/questions/11227809
x := sumOfIntsWithThreshold(a, 128)
```

Other good "why" examples are code being written in a less-intuitive way to make a particular test possible or to avoid a specific edge-case - be sure to note what those are.

If a well-researched algorithm is being used, definitely add a reference to it, including the best URL you have for someone who wants a quick overview of how it works.

## Document "why not" {#why-not}

In some code, the reader might see something missing, a pattern apparently broken. Sometimes this is for a good reason, as keeping with the pattern would cause a bug. More specifically, you might be *fixing* a bug by breaking the pattern.

In this example, especially if you're removing a line `sort.Strings(c)`, it's a good idea to leave a comment explaining why it shouldn't be there.

```go
func handle(a, b, c []string) {}
    sort.Strings(a)
    sort.Strings(b)
    // don't sort c, we need to keep its original order for foo
    foo(c)
}
```

## Don't document "what" when it's trivial {#trivial}

You might be asking yourself "what's the harm in a comment if it isn't needed. The answer is that it can be misleading; code will function correctly even if it's out-of-sync with its comments, so comments aren't always updated when code is changed, leading to this canonical example:

```go
// increment x by 1
x += 2
```

In less-trivial cases, the reader can be left scratching their head for far longer than they would've if the comment weren't there in the first place.

## Documenting "sections" is a code smell {#sections}

If your code looks is divided using comments into "sections", it's probably long and difficult to reason about:

```go
func ServeSite(o io.Writer) {
    //// Get site data ////
    f := os.Open("data.md")
    defer f.Close()
    parser := markdown.NewParser(f)
    data := parser.Parse()

    //// Get layout data ////
    f2 := os.Open("layout.cfg")
    defer f2.Close()
    layoutReader := awesomelayout.NewReader(layoutOpts.Defaults)
    // Name "data" is already in use"
    dataOfLayout := layoutReader.Read(f2)

    //// Set up HTML renderer ////
    renderer := htmlrender.NewRenderer()
    renderer.SetHTMLMode("my-favorite-html-style")
    renderer.SetCompression("max-compression")

    renderer.Render(o, data, dataOfLayout)
}
```

This gets even messier if you don't sneakily omit error handling. In any case, the section headers are reasonable (albeit not great) candidates for function names:

```go
func ServeSite(o io.Writer) {
    siteData := getSiteData()
    layoutData := getLayoutData()
    renderer := setupHTMLRenderer()
    renderer.Render(o, data, dataOfLayout)
}

func getSiteData() markdown.Data {
    f := os.Open("data.md")
    defer f.Close()
    p := markdown.NewParser(f)
    return p.Parse()
}

func getLayoutData() awesomelayout.Data {
    f := os.Open("layout.cfg")
    defer f.Close()
    r := awesomelayout.NewReader(layoutOpts.Defaults)
    return layoutReader.Read(f)
}

func setupHTMLRenderer() htmlrenderer.Renderer {}
    r := htmlrender.NewRenderer()
    r.SetHTMLMode("my-favorite-html-style")
    r.SetCompression("max-compression")
    return r
}
```

The main `ServeSite` function is now much easier to read. The "section names" are now function names, and are less likely to fall out of date. And as a bonus, the scope of many variables is reduced - so the reader doesn't have to keep them in mind, and we can use short names for them.

## Don't leave code scars around {#code-scars}

Finally, just a pet peeve - while it's absolutely fine to "comment out" code while developing, you usually shouldn't commit this to version control. I like calling these "code scars":

```go
x := getMaxValue()
// x = 3
handle(x)
```

In this case, `x = 3` was there for testing "what if `getMaxValue` returns 3". You should not commit this. However, a possible exception can be if you're documenting "why not" as above - if it comes with an explanation.

## Conclusion

Code is meant to be read by machines and humans, with comments generally being intended for humans to read. Therefore, all of these should be taken as guidelines rather than gospel. Hopefully this post can be of some use for people trying to reason about comment etiquette, or perhaps for code reviewers wanting to point their reviewees at a preexisting summary.
