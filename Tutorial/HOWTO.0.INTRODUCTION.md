How I decided to continuously remaster my own Debian Variant without, like, totally meaning to.
===============================================================================================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.0.INTRODUCTION.md)

OK, this thing is a work in progress, so bear with me while I do it, but here's
what I'm attempting. I have spent alot of time refining my home PC's
configuration based on defaults in the Debian installer, and the packages
themselves, and I've been pretty successful at it. But it's an ongoing process,
and sometimes, you bork something and you've got to reinstall. Which means that
you've got to reproduce all that configuration and start over, which kind of
sucks. There are many ways to approach this, and what this readme is going to
amount to is simply an example of but one way of doing things(With some
variations, because some of the things that Docker can allow you to do are
awesome). I wanted a lightweight media-center OS for retro gaming that could
double as a Media Server, I totally uncreatively called it hoarderMediaOS, and
now it's a reasonably easy to reproduce procedure and I hope it's helpful. It's
based on Unstable, though, so it's might become outdated at any moment. I'm
going to keep doing it though, so I'll probably notice if it stops working.

Who this tutorial is targeted at
--------------------------------

Enthusiastic Amateurs! People who like Debian/Ubuntu based distributions for
their excellent stability and diligent community, but who don't necessarily
want to use one of the regular desktop environments in the default
configuration. Ricers, datahoarders, and hobbyists who would rather use Debian
than Arch or Gentoo. Anyone who uses their home computer for experimentation.
The point of this tutorial is that **anyone** can learn to continuously
customize their Linux configuration if they wish to, **anyone**, even a solitary
hobbyist with no significant organizational resources.

**Is it a distro?**

**God I hope not.** I'm not a person who really likes to deal in opinion. I
deleted my whole blog because I felt obligated to be personal. Unfortunately,
I have an opinion. I'm opinionated. And it's my opinion that it's too easy for
people to consider any installable media that gets redistributed equal to a
recognizable distro. It's just not. Tiny distros can be **amazing**, I loved
CrunchBang and felt genuine sadness when corenominal gave it up, and genuine
excitement for BunsenLabs and Crunchbang++. I love Linux Mint and think
Cinnamon will ease many people's Dad's transition into using GNU/Linux from
Windows when they start to get pissed off about Windows 10 serving them ads
all the damn time. But there are caveats to using these tiny niche distros. You
have to take matters into your own hands at times, even things that are second
nature to you or me, might not be obvious to a first-time Mint user, even things
as simple as being able to use AskUbuntu to get help.

Depending on their complexity, they may also configure 3rd-party repositorys.
**Please consider that in the most serious of terms**. If they configured a
third-party repository, they have probably used it to install something. That
application was installed from that third-party repository because it's probably
experimental and **not ready to be held to the standards of an official Debian**
**package**. That doesn't mean it's bad. Lots of software from third-party
repositories is **awesome** but using third party software is kind of a big
decision.

It is my opinion that there ought to be a clearer way to consider these two
types of distros specifically. Maybe something like "Upstream Distro" and
"Enthusiast Distro" as a place to instigate a lexical split, and make clear the
advantages, disadvantages, and implications of each. Using an "Enthusiast
Distro" is fun, and creating one is fun. Sharing them ought to be fun, too.
I would be more comfortable sharing my own "Enthusiast Distro" if I were sure
people understood, I'm just one guy, depending on the work of thousands, I think
building riced install media is fun, and that's **it**.

What am I actually going to talk about?
---------------------------------------

live-build, docker, sid, make. Specifically, I'm going to teach you how to use
these tools to continuously package your own personal configuration of Debian
as an iso that can be used to create install media, just like the regular Debian
LiveCD's.

What are you going to need?
---------------------------

Either Debian unstable(sid), Devuan unstable(ceres) or any distribution
supporting Docker and coming configured with the Docker Hub.

**On that note, Dependencies**

        Debian Sid/Devuan Ceres
        =======================
        sudo apt-get install live-build debootstrap make
        optionally,
        sudo apt-get install git docker.io

or install docker per your distribution's instructions or from source. Docker
will use the debian:sid container as a base. A git repository or a git hosting
service will also be helpful if you want to backup and share your configuration.
