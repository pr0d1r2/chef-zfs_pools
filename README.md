# chef-zfs_pools

Cookbook for generating ZFS setup/mount script with full disk
encryption and disk redundancy.

## Usage

Add this to your node.json (note that disk mapping keys are device nodes
located in `/dev/disk/by-id/` and mapping is done for convenience to not
require extra hardware management - `zfs-sda` means that disk with this
particular serial number is located in `sda` disk bay - as we are using
Rackable S3012 to build systems):

```json
{
  "run_list": [
    "zfs_pools"
  ],
  "zfs_pools": [
    {
      "name": "home",
      "mountpoint": "/home",
      "type": "raidz3",
      "disk_mapping": {
        "ata-TOSHIBA_HDWA120_8472ST001": "zfs-sda",
        "ata-TOSHIBA_HDWA120_8472ST002": "zfs-sdb",
        "ata-TOSHIBA_HDWA120_8472ST003": "zfs-sdc",
        "ata-TOSHIBA_HDWA120_8472ST004": "zfs-sdd",
        "ata-TOSHIBA_HDWA120_8472ST005": "zfs-sde",
        "ata-TOSHIBA_HDWA120_8472ST006": "zfs-sdf",
        "ata-TOSHIBA_HDWA120_8472ST007": "zfs-sdg",
        "ata-TOSHIBA_HDWA120_8472ST008": "zfs-sdh",
        "ata-TOSHIBA_HDWA120_8472ST009": "zfs-sdi",
        "ata-TOSHIBA_HDWA120_8472ST010": "zfs-sdj",
        "ata-TOSHIBA_HDWA120_8472ST011": "zfs-sdk",
        "ata-TOSHIBA_HDWA120_8472ST012": "zfs-sdl"
      },
      "sub_resources": {
        "INBOX": [
          {
            "name": "Inbox",
            "mountpoint": "/home/Inbox"
          }
        ]
      }
    }
  ]
}
```
