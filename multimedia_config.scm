;; modified from the graphical
;; 1.3.0-installer to stabilize multi-monitor behaviour
;; with system upgrades. This is done by pinning a kernel
;; visible from the initial installation guix-commit.
;; mainly adapted from https://gitlab.com/nonguix/nonguix

(use-modules (gnu)
	     (gnu packages)
	     (srfi srfi-1)
	     (guix)
	     (guix channels)
	     (guix inferior))
(use-service-modules
 desktop
 networking
 ssh
 xorg)
(operating-system
 (kernel
  (let*
      ((channels
	(list (channel
	       (name 'guix)
	       (url "https://git.savannah.gnu.org/git/guix.git")
	       (commit "be067c908c90b9d9f798fdf36f744f72c884f3bd"))))
       (inferior
	(inferior-for-channels channels)))
    (first (lookup-inferior-packages inferior "linux-libre"  "5.10.42"))))
 (locale "de_DE.utf8")
 (timezone "Europe/Vienna")
 (keyboard-layout (keyboard-layout "de"))
 (host-name "laptop")
 (users (cons* (user-account
		(name "daniel")
		(comment "Daniel")
		(group "users")
		(home-directory "/home/daniel")
		(supplementary-groups
		 '("wheel" "netdev" "audio" "video")))
	       %base-user-accounts))
 (packages (append (map specification->package
			'("nss-certs"))
		   %base-packages))
 (services
  (append
   (list (service gnome-desktop-service-type)
	 (set-xorg-configuration
	  (xorg-configuration
	   (keyboard-layout keyboard-layout))))
   %desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (target "/boot/efi")
   (keyboard-layout keyboard-layout)))
 (mapped-devices
  (list (mapped-device
	 (source
	  (uuid "e3abd143-5cdd-438a-b316-ef7297aae979"))
	 (target "cryptroot")
	 (type luks-device-mapping))))
 (file-systems
  (cons* (file-system
	  (mount-point "/boot/efi")
	  (device (uuid "88A8-FC68" 'fat32))
	  (type "vfat"))
	 (file-system
	  (mount-point "/")
	  (device "/dev/mapper/cryptroot")
	  (type "ext4")
	  (dependencies mapped-devices))
	 %base-file-systems)))
