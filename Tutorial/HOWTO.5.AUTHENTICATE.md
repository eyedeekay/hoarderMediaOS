Step 4: Provide a path to verify Authentic copies
=================================================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.5.AUTHENTICATE.md)

Like I said, we should all be careful about who we trust to assemble all our
software. Likewise, when you distribute it in binary form, it probably makes
sense to provide many ways to verify that the recipient of that copy has
obtained it authentically. To do this, you have many options, and you should
choose to use them all if possible.

Compute Hashes
--------------

The first step to helping your fellow enthusiast to verify the authenticity of
an image, you need to compute hashes of those images. A *hash function* takes
an arbitrary piece of data, any data will do, and creates a string of a fixed
size which is totally unique to the piece of data that was *hashed*. So when we
sha256sum our iso file, we will get a string that is unique to our iso file and
cannot be reproduced, without an exact copy of the original iso file. The tool
we should use for this is sha256sum, which computes hashes based on the Secure
Hashing Algorithm, the 256 bit version, which is used by many GNU/Linux
distributions to verify the authenticity of their distributed iso files.

In order to produce the sha256sum of the iso file, run the following command. It
make take a moment, especially if the file is large in size.

        sha256sum tv-amd64.hybrid.iso

Once the hash is computed, it will be emitted to stdout in the form

        86b70a74e30eec40bf129c44a8dd823c1320200825bc4222556ce1241d4863dd  tv-amd64.hybrid.iso

This can now be used to ensure that the file corresponds to the hash, which is
one half ot the authenticity puzzle. If you want to compute the hashes in your
Makefile, you could use something like the following snippet.

        **Example Makefile Fragment: hash, delete empty on failure**
        hash:
                sha256sum tv-amd64.hybrid.iso > \
                        tv-amd64.hybrid.iso.sha256sum || \
                        rm tv-amd64.hybrid.iso.sha256sum; \

Because piping the output of sha256sum will always produce a file, but if the
file to be hashed doesn't exist, the created file will be empty, we make sure
that sha256sum signals that it has completed *successfully* and if it fails, we
delete the created file.

Sign Hashes
-----------

Now we've got hashes to verify the iso's correspond to the hashes, but now we
need a way for the user to verify the provenance of the hashes themselves. In
order to do this, we need to sign them with a key that corresponds to some real
set of contact information. Traditionally, this has been an e-mail but maybe
something out there is better for you.

To get started, we need to generate a signing key. If you already have a signing
key you want to use, then you can skip this step.

[See Also: Key Generation/Distribution](https://wiki.debian.org/Keysigning#Step_1:_Create_a_RSA_keypair)

[Also See Also: Key Generation](https://keyring.debian.org/creating-key.html)

Before you do anything else, you should edit your $HOME/.gnupg/gpg.conf to not
use SHA1 as it's hashing algorithm.

        personal-digest-preferences SHA256
        cert-digest-algo SHA256
        default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

Now, you'll need to start the gpg key generation procedure:

        gpg --gen-key

You'll be prompted for whick key type you want to generate. RSA and RSA, the
default key type, is the one that we want. On the next prompt, you'll be
prompted to select a key size, and you should select 4096 for your signing key.
Then select a time frame for the key to be valid. For the sake of brevity, I
direct you to the second
[link at the top of this section](https://keyring.debian.org/creating-key.html).

Now that you're done with that, you've just got to get ready to share your key.
First, generate a key revocation certificate. Back it up someplace safe. You
will use it in case your private key is ever compromised to inform people that
they must disregard the compromised key and update to an uncompromised key.

        gpg --gen-revoke ${KEY_ID} > ~/.gnupg/revocation-${KEY_ID}.crt

Finally, share the **public** key with the world.

        gpg --send-key ${KEY_ID}

Now that we've got our signing key, let's use it to sign the files:

        gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" tv-amd64.hybrid.iso.sha256sum

After you're done, you'll have a signed copy of the hash file that looks like
this:

        -----BEGIN PGP SIGNED MESSAGE-----
        Hash: SHA256

        86b70a74e30eec40bf129c44a8dd823c1320200825bc4222556ce1241d4863dd  tv-amd64.hybrid.iso
        -----BEGIN PGP SIGNATURE-----

        iQEzBAEBCAAdFiEEwM7uKXtf5F/2EKrG8F+F+kRsBCsFAllIqBoACgkQ8F+F+kRs
        BCubMwgAuf81nTIcmM8COY7T7RGp51ApiAMETU1tuHQbOKBKDRemgml2UZ0DNVLZ
        wCtnfErsQD8getUSpqSk07e448sCbEUYeifH8xS/6uC3JbCkITt4bDl6UdU2BXm0
        I9IkweK3d0hp5TIjs4m9fA3qVTto1v9EaUxQhREB3/do2FhqP+60ehqR3dgqLzOr
        5ueXxXCeFAHJhyvQk0EvKwvWciabqj8gY2ra5aEXE+kAJWz8mrLyK/4Q0IBwXMYm
        xPiXNctlaldqDCjsF42ronHQlHK7pg0l58Pht/kSh8ERKPyhtLGeOOrNyjcbg8/t
        HE65ErJ7ArZZJQ7KBdxFr8lzkrPsEg==
        =PrNx
        -----END PGP SIGNATURE-----

and can be used by anyone with your public key to assure that the hash they
are using, and thus the iso it corresponds to, came from the owner of the
corresponding private key and them alone. In order to make the signatures with
the Makefile, a fragment like the following will work. Note that we don't have
to delete failed signatures, a nonexistent file will just not produce a
signature.

        **Example Makefile Fragment: sign the hash**
        sign:
                gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
                        tv-amd64.hybrid.iso.sha256sum ; \
