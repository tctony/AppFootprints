# 依赖工具
* Xcode
* Python 2.7

# 使用步骤
* 将AppFootprints文件夹添加到代码目录中
* 在build phrase中添加run script来生成footprint map
  `python path/to/GenFootprintMap.py`
  并编译一次生成FootprintMap.[h,m]
* 将QHAppFootprints.[h,m], FootprintMap.[h,m]添加到工程中
  建议将FootprintMap.[h,m]添加到svn ignore或git ignore中
* 使用HLogFootprint在代码中记录用户操作
* 运行App一段时间后，提取footprint，解码footprint
`python path/to/DecodeFootprint.py 'footprint string'`

# TODO
* HLogFootprint简化
* footprint运行时输出自定义
* 增加配置文件：配置FootprintMap.[h,m]文件路径
