
# version:python 3.7.9      pytorch :1.7.0
# function:利用神经网络进行鸢尾花分类

import numpy as np
import torch
from collections import Counter
from sklearn import datasets
import torch.nn.functional as Fun

# 1. 数据准备
dataset = datasets.load_iris()
data = dataset['data']
labels = dataset['target']

input=torch.FloatTensor(data)
label=torch.LongTensor(labels)

# 2. 定义BP神经网络
class Net(torch.nn.Module):
    def __init__(self, n_feature, n_hidden, n_output):
        super(Net, self).__init__()
        self.hidden = torch.nn.Linear(n_feature, n_hidden)   # 定义隐藏层网络
        self.out = torch.nn.Linear(n_hidden, n_output)   # 定义输出层网络

    def forward(self, x):
        x = Fun.relu(self.hidden(x))      # 隐藏层的激活函数,采用relu,也可以采用sigmod,tanh
        x = self.out(x)                   # 输出层不用激活函数
        return x

# 3. 定义优化器损失函数
net = Net(n_feature=4, n_hidden=20, n_output=3)    #n_feature:输入的特征维度,n_hiddenb:神经元个数,n_output:输出的类别个数
#optimizer = torch.optim.SGD(net.parameters(), lr=0.02) # 优化器选用随机梯度下降方式
optimizer = torch.optim.Adam(net.parameters(), lr=0.01)
loss_func = torch.nn.CrossEntropyLoss() # 对于多分类一般采用的交叉熵损失函数,

# 4. 训练模型
EPOCH=80
for t in range(EPOCH):
    out = net(input)                 # 输入input,输出out
    loss = loss_func(out, label)     # 输出与label对比
    optimizer.zero_grad()   # 梯度清零
    loss.backward()         # 前馈操作
    optimizer.step()        # 使用梯度优化器

# 5. 测试模型
testing_correct = 0
outputs = net(input) #out是一个计算矩阵，可以用Fun.softmax(out)转化为概率矩阵
_, pred = torch.max(outputs.data, 1)
testing_correct += torch.sum(pred == label.data)
accuracy = float(testing_correct/ len(data))
print("莺尾花预测准确率为:{:.4f}%".format(accuracy))
