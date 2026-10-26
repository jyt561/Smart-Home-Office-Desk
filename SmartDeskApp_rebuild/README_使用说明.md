# SmartDeskApp 界面重建 - 使用说明

## 这是什么

用 MATLAB 程序化方式(uifigure)重建的 AI Smart Desk System 界面,
和原程序(SmartDeskApp.exe)的功能布局一一对应,并新增了语音控制页:

| 页面 | 功能 |
|------|------|
| A Posture & Rhythm | 桌高控制 / 久坐检测 / AI 坐姿识别 / 工时监测 / 身高学习 |
| B Adaptive Lighting | 亮度色温 / 环境光感应 / 照明模式 / 灯光预览 |
| C Safety & Controls | 安全状态 / 一键操作 / 操作日志 / 电机状态 |
| D Environment | 香氛 / 风扇 / 湿度 / 情绪氛围灯 / 组合场景 |
| E Space & Objects | 物品查询 / RFID 状态 / 桌面网格 / AI 整理建议 |
| F Privacy | 存储策略 / 传感器开关 / AI 权限 / 用户档案 / 决策日志 |
| G Scene Switcher | 8 个场景卡片 / 桌面倾角 / 嵌入屏设置 |
| H Voice Control(新增) | 语音识别+播报 / 麦克风电平 / 命令测试器 / 命令日志 |

## H 页语音功能说明

- 基于 Windows 自带 .NET System.Speech,无需 MATLAB 工具箱
- 约 70 条英文语音指令,覆盖 A–G 全部模块:
  桌高(sit down/stand up/set height 70~110)、
  照明(brightness up/down、7 种模式、auto dim)、
  安全(check safety、reset desk)、
  环境(fan up、scent on、lavender scent、mood focus、组合场景)、
  物品(find phone/keys/cable、register item)、
  隐私(privacy report、stop automation)、
  场景(8 种 mode + tilt 0/15/30)、系统(status/help)
- 每条指令:跳转对应页面 → 执行操作 → 界面联动 → 语音播报 → 写日志
- Command Tester 可无麦克风模拟语音输入(演示用)
- 无麦克风时自动降级为模拟模式(电平条自动演示跳动)

## 运行前提(重要)

需要**完整版 MATLAB R2023a 或更新版本**(任意版本均包含 App Designer 和 uifigure,
不需要额外工具箱)。

注意:你电脑上目前装的 MATLAB Runtime 只是运行时,不能运行本代码。
获取完整版 MATLAB 的正规途径:

1. 高校校园正版授权(推荐,免费):到学校信息化办公室/网络服务中心的
   "正版软件平台"下载,登录时选择校园许可证
2. MathWorks 官方 30 天试用:https://www.mathworks.com/campaigns/products/trials.html
3. 个人版(Home)授权

## 运行方法

1. 安装好完整版 MATLAB 后打开它
2. 把 `SmartDeskApp.m` 复制到任意文件夹,并在 MATLAB 中 cd 到该文件夹
   (或拖入 MATLAB 当前文件夹窗口)
3. 命令行窗口输入:

```matlab
SmartDeskApp
```

即可看到和原程序一致的界面。

## 已实现的可交互功能

- 侧边栏 A-G 七个按钮切换页面(蓝色高亮跟随)
- A 页:桌高滑块实时显示数值;Sitting/Standing 按钮一键设 72/108cm;
  Learn New Preference 按钮把当前桌高记入偏好列表
- B 页:亮度/色温滑块联动数值;照明模式切换联动预览图
- C 页:6 个操作按钮带时间戳写入操作日志,电机状态同步更新
- D 页:香氛/风速/湿度滑块联动数值;氛围灯模式切换
- E 页:物品搜索(高亮命中项)、RFID 登记新物品
- F 页:存储模式单选、传感器/AI 权限复选、清除数据弹出确认框
- G 页:8 张场景卡片点击切换当前场景;倾角滑块联动数值
- 全局:右下角实时时钟,关闭窗口自动停止定时器

## 后续可扩展

- 代码结构:一个主函数 + 每页一个 build 函数 + 共享回调,直接在对应
  build 函数里改控件即可
- 若要改为 App Designer 的 .mlapp 工程,可在 App Designer 中新建后
  用"代码视图"参考本文件的属性设置逐控件迁移
