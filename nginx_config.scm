;; This is an operating system configuration generated
;; by the graphical installer.
;; kernel pinned for more upgrade stability

(use-modules (gnu)
	     (gnu packges)
	     (srfi srfi-1)
	     (guix)
	     (guix channels)
	     (guix inferior))
(use-service-modules
 desktop
 networking
 ssh
 web
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
  (host-name "chm")
  (users (cons* (user-account
                  (name "convex")
                  (comment "Convex Hull Emulator")
                  (group "users")
                  (home-directory "/home/convex")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
     (list (specification->package "nss-certs")
	   (specification->package "yasm"))
	   %base-packages))
  (services
    (append
     (list (service dhcp-client-service-type)
	   (service nginx-service-type))
      %base-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "83e5cd3f-8db0-4777-b7a0-01db4b7b704b")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "322db0b3-724a-4afc-ade5-aeb43e7cd127"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
