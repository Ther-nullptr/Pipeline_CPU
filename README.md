# 随记

## 模块命名

1. 以大驼峰格式命名，如`module AaBbCc`。
2. module例化使用前缀：‘U_’ 或 ‘Ux_’。如`Adder U_Adder`。

## 信号命名

1. 以小驼峰格式命名，如`wire memWrDat`。

2. 前缀用于标志信号的特殊用途或特殊含义，以一个小写字母写在信号名前，信号名为大驼峰命名，整个信号为小驼峰命名。（也可以用下划线+全小写）

> input: i (input port)， 例如：iAaaBbb
> inout: b (bi-directional port)， 例如：bAaaBbb
> output: o (output port)， 例如：oAaaBbb
> 寄存器：r (register) ，例如：rAaaBbb 。
> 锁存器：l (latch) ，例如：lAaaBbb 。

3. 后缀用于在不改变信号名情况下表示信号属性变化，命名方式：信号名 + ‘_’ + 后缀 。所有前缀都可以用于后缀。

## 参数、宏命名

所有字母全部大写，建议以`P_`开头。
