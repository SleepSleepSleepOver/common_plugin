使用说明：

1.HttpUtils 为网络请求工具类，需要在自有项目内，登录完成后手动设置 SpUtil.putString('token', data['access_token']); 如不需要 token 直接使用网络请求图片或者其他资源，即设置 needAuthor 为 false

2.HomeBasePage 仅为 HomePage 基类，需要在 HomePage 页面以 class _HomePageState extends BaseState< HomePage > with Upgrade 方式使用， 集成了远程视频监听，需要开启远程视频即： FBroadcast.instance().broadcast(WConstant.VIDEOSTART, value: {"channel": roomId, 'appid': agoraId}, callback: (b) { if (b) { /// 成功进入视频房间后回调 } }); 需要在其他地方结束远程视频： FBroadcast.instance().broadcast(WConstant.VIDEOEND) 否则默认点击结束开关即触发该广播 重载 body 方法传入页面布局，升级更新（可选）可调用 check 方法，传入升级参数。

3.BasePage widget 类型基本占位页面，适用局部或整页加载中，加载失败，加载完成显示指定数据

4.CustomAppBar widget 类型标题栏，左中右布局，右侧组件可自定义

5.FullBasePage 结合 CustomAppBar+传入布局的整页基础组件

6.WToast 显示短暂提示语，加载图标，复杂蒙层使用 BotToast.showEnhancedWidget 实现

7.WDialog 实现标准对话框

8.WCustomDialog 实现自定义模态窗口的外层，内部布局自行传入，比如底部列表弹出框等，性能比 showBottomSheet/showModalBottomSheet 好太多，解决了 showModalBottomSheet 无法设置高度问题

9.WPopupWindow 实现界面上局部点击的弹出层，下拉框等

10.FBroadcast 代替 EventsBusUtils，实现广播数据，粘性广播，持久数据，等，详细参考官方 demo, 页面关闭需要在 dispose 内 FBroadcast.instance().unregister(this);

11.Fdottedline 为虚线

12.WDot 为右上角小红掉或者数字

13.WText 为避免用户设置系统字体大小，固定了字号

14.WTabNavi 是顶部 tab 切换类型组件，多样式可选

15.WSwitch 为开关按钮，2 种样式

16.WLoading 默认为菊花转动动画组件，被包含在 WToast 中，可传入不同加载图片

17.WLine 为分割线，纵横皆可，比系统默认提供的 Divider 组件显示更加清晰，不会模糊

18.WItem 为默认 54 高度的带右箭头的单行可点击组件

19.WCheckBox 为可自定义背景和渐变色的多选组件

20.WCard 为带圆角和阴影的卡片类型可点击组件

21.WButton 为多样式按钮组件，实体型，边框型，渐变等

22.RealRichText 实现的是更简便的富文本类型组件，数组传入即可

23.VideoView 是声网视频组件，已经集成在 HomeBasePage，无需单独使用

24.PhotoView 是相册组件，可传入图片数组，本地，网络，assets 类型，可选 token

25.MessageVoice 是语音录入组件，发送语音，录音等地方使用，自带录音插件和界面效果

26.CustomDotBuilder 需要结合 flutter_swiper 插件使用，实现自定义指示器作用

27.player 是腾讯播放器组件，使用方式参考树兰医生

28.datePicker 是日历选择组件，使用方式参考树兰医生

29.占位使用 SizeBox 控件

30.工具类使用参考https://pub.flutter-io.cn/packages/common_utils

31.路由全系使用 RouteHelper，context 安全使用方式为 main.dart 中 MaterialApp 提升至 runApp 内，在 MaterialApp 的 home 属性设置 MyApp，在其 initState 中设置 Constant.appContext = this.context;即可全局引用，详细 main.dart 设置参考树兰医生工程

32.localizations.dart 不再提供中文国际化，使用系统提供的 localizationsDelegates: [ GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, ],

33.CommonUtils 为工具类，结合三方库 common_utils 可以实现各种格式化