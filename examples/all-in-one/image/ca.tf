data "linuxkit_kernel" "kernel" {
  image   = "linuxkit/kernel:5.6.11"
  cmdline = "console=tty0 console=ttyS0 console=ttyAMA0"
}

data "linuxkit_init" "init" {
  containers = [
    "linuxkit/init:8f1e6a0747acbbb4d7e24dc98f97faa8d1c6cec7",
    "linuxkit/runc:f01b88c7033180d50ae43562d72707c6881904e4",
    "linuxkit/containerd:de1b18eed76a266baa3092e5c154c84f595e56da",
    "linuxkit/ca-certificates:c1c73ef590dffb6a0138cf758fe4a4305c9864f4",
  ]
}

data "linuxkit_image" "sysctl" {
  name  = "sysctl"
  image = "linuxkit/sysctl:bdc99eeedc224439ff237990ee06e5b992c8c1ae"
}

data "linuxkit_image" "rngd1" {
  name    = "rngd1"
  image   = "linuxkit/rngd:4f85d8de3f6f45973a8c88dc8fba9ec596e5495a"
  command = ["/sbin/rngd", "-1"]
}

data "linuxkit_image" "getty" {
  name  = "getty"
  image = "linuxkit/getty:76951a596aa5e0867a38e28f0b94d620e948e3e8"
  env   = ["INSECURE=true"]
}

data "linuxkit_image" "rngd" {
  name  = "rngd"
  image = "linuxkit/rngd:4f85d8de3f6f45973a8c88dc8fba9ec596e5495a"
}

data "linuxkit_image" "dhcpcd" {
  name  = "dhcpcd"
  image = "linuxkit/dhcpcd:52d2c4df0311b182e99241cdc382ff726755c450"
}

data "linuxkit_image" "dhcpcd1" {
  name    = "dhcpcd"
  image   = "linuxkit/dhcpcd:52d2c4df0311b182e99241cdc382ff726755c450"
  command = ["/sbin/dhcpcd", "--nobackground", "-f", "/dhcpcd.conf", "-1"]
}

data "linuxkit_image" "sshd" {
  name  = "sshd"
  image = "linuxkit/sshd:4696ba61c3ec091328e1c14857d77e675802342f"
}

data "linuxkit_image" "metadata" {
  name  = "metadata"
  image = "linuxkit/metadata:646c00ad6c0b3fc246b6af9ccfcd6b1eb6b6da8a"
}

data "linuxkit_image" "step" {
  name  = "step"
  image = "smallstep/step-ca:0.22.1"
}

data "linuxkit_config" "step" {
  kernel = data.linuxkit_kernel.kernel.id
  init   = [data.linuxkit_init.init.id]

  onboot = [
    data.linuxkit_image.sysctl.id,
    data.linuxkit_image.rngd1.id,
    data.linuxkit_image.dhcpcd1.id,
    data.linuxkit_image.metadata.id,
  ]

  services = [
    data.linuxkit_image.getty.id,
    data.linuxkit_image.rngd.id,
    data.linuxkit_image.dhcpcd.id,
    data.linuxkit_image.sshd.id,
    data.linuxkit_image.step.id,
  ]
}

resource "linuxkit_build" "step" {
  config_yaml = data.linuxkit_config.step.yaml
  destination = "${path.module}/step.tar"
}

resource "linuxkit_image_raw_bios" "step" {
  build       = linuxkit_build.step.destination
  destination = "${path.module}/step.raw"
}

resource "linuxkit_image_vmdk" "step" {
  build       = linuxkit_build.step.destination
  destination = "${path.module}/step.vmdk"
}
