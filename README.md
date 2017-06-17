hoarderMediaOS
==============

or...

How I decided to continuously remaster my own Debian Variant without, like,
===========================================================================
totally meaning to.
===================

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
want to use one of the regualar desktop environments in the default
configuration. Ricers, datahoarders, and hobbyists who would rather use Debian
than Arch or Gentoo. Anyone who uses their home computer for experimentation.

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

Step One: Auto Scripts
======================

You should create an empty directory for your configuration.

Step Two: Makefile
==================

Step Three: Dockerfile
======================
