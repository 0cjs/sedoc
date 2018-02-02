BitLocker
=========

BitLocker has several “encryption modes” for the boot drive. The
standard one on systems with a TPM is to store the key there and
immediately use that to decrypt during boot after confirming that the
correct boot partition is used and it’s not been tampered with. This
can be combined with external key material from a USB device and/or a
PIN or password. If you have a TPM you should use TPM+PIN; if not you
should use long passphrase.

BitLocker uses a separate unencrypted partition to store the initial
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

By default Windows 10 (as of fall 2017) appears not to allow "preboot
authentication" with a PIN or password, regardless of whether or not
you have a TPM. This is set by a group policy which can be updated as
follows:

1. Run `GPEDIT.MSC`
2. Navigate down through
    * Computer Configuration
    * Administrative Templates
    * Windows Components
    * BitLocker Drive Encryption
    * Operating System Drives
3. Enable the "Require additional authentication at startup" policy
   item and check that the settings enable use of a PIN.
4. If you have no TPM, you may also need to ensure that "Allow Bit
   Locker without a compatible TPM" is checked.

With PIN enabled via this policy, enabling BitLocker for the OS drive
in the control panel will prompt you for an optional PIN during the
setup phase. If BitLocker is already enabled for the drive, after you
change the policy you can add a PIN by entering the following at an
administrative command prompt:

    manage-bde -protectors -add C: -TPMAndPIN

Some sources indicate that if using BitLocker without a TPM you must
use a startup key from an external drive. This is not the case, at
least for Windows 10: if the Group Policy configuration above is set
appropriately you can use just a passphrase or PIN even on systems
without a TPM (though using a PIN or short passphrase will probably
not be very secure).

### Recovery Keys

Changes to your system, particularly to drive from which you boot, may
disable a PIN or passphrase and require the use of a recovery key. For
example, on a TPM-enabled system with BitLocker activated, replacing
the Windows boot sector with Grub (to dual-boot Windows/Linux) will
invalidate your PIN. (My guess is that the TPM won't check a PIN
unless it can confirm that the boot sector and/or other early boot
material on the drive has not been changed.)

The recovery key is now just a 40-digit number in ASCII format; the
binary file version is no longer written or used. Windows writes the
information in a file named like `BitLocker Recovery Key
3BAC6D5B-79C1-49C6-AA02-22975F275C8A.TXT` and can directly read this
file during the boot or recovery process.

When booting, if you have plugged in an external disk with the
recovery key on it a prompt for a PIN or passphrase will be skipped.


References
----------

* Stack Overflow [answer to _How do I set the BitLocker PIN?_][bl-pin].
* MS forum [_Bitlocker in Windows 10 without TPM_][bl-no-tpm] (see the
  answer from Vijay B on 2015-06-05).



[bl-pin]: https://serverfault.com/a/55495/7408
[bl-no-tpm]: https://answers.microsoft.com/en-us/windows/forum/windows_10/bitlocker-in-windows-10-without-tpm/f79add65-17c2-4a5d-92d6-e4d2a387119f
