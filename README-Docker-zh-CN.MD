# 硬件准备

## 开发版选择 

建议选择能刷比较新的armbian的开发版作为PI-KVM

##### 1.选择原生带有OTG的开发版 例如:

- Orange Pi Prime(貌似已停产)

- Orange Pi Zero(需要制作一分二数据线 性能比较差 适合低成本1080P 30FPS方案)

- Orange Pi Zero LTS(和Orange Pi Zero一样)
  - 等其他 未列举完

##### 2.选择非原生支持修改dtb来实现OTG功能的开发版 例如:

- King 3399 (1个USB3.0 和一个Type-c 3.0做为OTG 能够满足1080P 60FPS方案)
- phicomm n1 (理论可以 把刷机那USB作为OTG 未做测试 不建议购买 性价比并不高)
- 友善Nanopc T4 （type-c口为OTG接口，type-c接口模式默认为dr_mode=“otg”，为了兼容性需要修改为dr_mode = "peripheral"）
  - 等其他 未列举完 

## 视频采集设备选择 HDMI转USB

- 如果你的开发版只有USB 2.0 建议选择ms2109 而且价格便宜 tb 30 RMB左右的即可

- 如果你的开发版有USB 3.0 建议选择ms2130 淘宝偏贵点 可输出1080P 60FPS
  - 以上设备我都已测试可以用 但是 部分主板可能使用这两款视频采集设备都会导致进BIOS颜色输出有问题(又不是不能用)

- 其他的视频采集设备也可以 你可以试试???

## OTG数据线准备

- 开发版OTG口为单独的Type-C口或Micro USB 那么 你只需要准备一根数据线即可
- 开发版OTG口为开发版供电 你需要手动制作一分二数据线 如下图

![1to2](https://raw.githubusercontent.com/toss-a/pikvm-armbian/master/1to2.png)

- 开发版OTG口为USB 修改dtb后实现的  你需要准备USB-A 转 USB-A 线缆

  建议切断 USB 线的电源线，它可能会导致 OTG 断开连接。

#### 第一步

- 刷入 armbian 用于您的开发版或电视盒（如果内核不支持 otg，您应该构建一个启用 otg 功能的内核）

#### 第二步

- 修改您的 dtb 文件以启用 otg 功能。对于 otg USB 端口，将 dr_mode 从host更改为peripheral。
- 修改方法(Linux 推荐 Ubuntu)
  - sudo apt install device-tree-compiler
  - dtc 你开发版dtb -I dtb -O dts -o 输出的名称.dts
  - 修改 将dr_mode = "host" 修改为dr_mode = "peripheral"
  - dtc 刚刚修改的dts.dts -I dts -O dtb -o 你开发版.dtb
  - 替换,然后重启你的开发版

#### 第三步

- 安装docker（自行安装，不做过多说明）

#### 固定USB采集卡路径

- 检查采集卡当前路径(拔掉采集卡和插入采集卡可以看到内核分配的为video序号)

  ```bash
  ls -l /dev | grep video
  ```

- 获取视频采集设备的名称和索引（我目前的采集卡为/dev/video4）

  ```bash
  udevadm info --name=/dev/video4 --attribute-walk
  ```

- 在输出的内容中找到ATTR{name}和ATTR{index}，以下是我输入命令后输出的内容

  ```
  Udevadm info starts with the device specified by the devpath and then
  walks up the chain of parent devices. It prints for every device
  found, all possible attributes in the udev rules key format.
  A rule to match, can be composed by the attributes of the device
  and the attributes from one single parent device.
  
    looking at device '/devices/platform/fe380000.usb/usb5/5-1/5-1:1.0/video4linux/video4':
      KERNEL=="video4"
      SUBSYSTEM=="video4linux"
      DRIVER==""
      ATTR{dev_debug}=="0"
      ATTR{index}=="0"
      ATTR{name}=="UVC Camera (534d:2109): USB Vid"
      ATTR{power/async}=="disabled"
      ATTR{power/control}=="auto"
      ATTR{power/runtime_active_kids}=="0"
      ATTR{power/runtime_active_time}=="0"
      ATTR{power/runtime_enabled}=="disabled"
      ATTR{power/runtime_status}=="unsupported"
      ATTR{power/runtime_suspended_time}=="0"
      ATTR{power/runtime_usage}=="0"
  ```
  
- 创建一个 udev 规则

  ```
  sudo vim /etc/udev/rules.d/99-usb-video.rules
  ```

- 添加规则（需要将你获取ATTR{name}和ATTR{index}进行修改）例如：
  
  ```
  SUBSYSTEM=="video4linux", ATTR{name}=="UVC Camera (534d:2109): USB Vid", ATTR{index}=="0", SYMLINK+="video-capture-card"
  ```
  
- 重新加载 udev 规则并插拔设备

  ```bash
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  ```

  

#### 部署docker版PIKVM（One-KVM）

- Docker 镜像部署

  **脚本部署**（项目来自 [One-KVM](https://github.com/mofeng-git/One-KVM)）
  
  ```
  curl -sSL https://one-kvm.mofeng.run/quick_start.sh -o quick_start.sh && bash quick_start.sh
  ```

- 按照提示选择/dev/video-capture-card路径的采集卡以及正确的采集卡音频设备等待部署完成即可
- 访问方式https://ip:4430

#### 感谢,如果没有他们我不可能做到

- [One-KVM](https://github.com/mofeng-git/One-KVM)
