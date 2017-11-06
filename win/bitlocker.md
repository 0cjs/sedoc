BitLocker
=========

BitLocker has several “encryption modes” for the boot drive. The
standard one on systems with a TPM is to store the key there and
immediately use that to decrypt during boot after confirming that the
correct boot partition is used and it’s not been tampered with. This
can be combined with external key material from a USB device and/or a
PIN or password. Use either TPM+PIN or a password for systems without
a TPM.

Bitlocker uses a separate unencrypted partition to store the initial
boot files; Windows usually handles this automatically.

Initial encryption can take several hours even for just a few tens of
GB of data. The computer can still be used, but it will be slower due
to the I/O load. If the computer is shut down, initial encryption will
resume when it’s restarted.

Note that BitLocker protection may need be suspended (from the Control
Panel) when doing a major upgrade (e.g., Windows 7 to Windows 8); this
does not decrypt the drive, but merely allows decryption without
authentication. You should resume authentication after the upgrade.

### Configuring Encryption Modes

This is optional if you have a TPM and don’t want to use a PIN or any
other additional authentication, but required to use a PIN or to use a
password if you have no TPM. This can be done after starting the drive
encryption process (either while the drive is encrypting or after it’s
encrypted); you may need to do the manage-bde part below after it’s
set up as I’ve not tested doing it before setup.

Run `GPEDIT.MSC` and go to "Computer Configuration > Administrative
Templates > Windows Components" where you can enable use without a TPM
and/or additional authentication. You’ll then need to run

    manage-bde -protectors -add c: -TPMAndPIN

This summary comes from [this Stack Overflow answer][bl-pin];
slightly more detailed instructions can be found in [this MS
forum post][bl-no-tpm].

[bl-pin]: https://serverfault.com/a/55495/7408
[bl-no-tpm]: https://answers.microsoft.com/en-us/windows/forum/windows_10/bitlocker-in-windows-10-without-tpm/f79add65-17c2-4a5d-92d6-e4d2a387119f

### Setting up Encryption

If you have a TPM, at this point you can use the standard procedure to
encrypt. From the Control Panel choose BitLocker Drive Encryption, and
enable it for whatever drives you like.Setup Without a TPM it’s very
similar to what’s described here and here , with the following
differences for Windows 10:

* You do not need to have a startup key on an external drive when not
  using the TPM; you can use just a password. However, if an external
  drive with the recovery key file is plugged in, the password prompt
  will be skipped.
* The recovery key is now just a 40-digit number in ASCII format; the
  binary file version is no longer written or used. Windows writes the
  information in a file named like `BitLocker Recovery Key
  3BAC6D5B-79C1-49C6-AA02-22975F275C8A.TXT` and can directly read this
  file as per above.
