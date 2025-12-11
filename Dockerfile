FROM homebrew/ubuntu24.04

# 修复apt权限问题并安装必要软件包（包含ping和telnet）
USER root
RUN mkdir -p /var/lib/apt/lists/partial && \
    chmod 755 /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y curl zsh git build-essential wget \
                       iputils-ping telnet net-tools tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置时区为上海时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# 修复 Git 安全目录问题
RUN git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew && \
    git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core && \
    git config --global --add safe.directory '*'

# 配置 Homebrew 镜像源
RUN cd "$(brew --repo)"

# 设置环境变量并安装软件
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV TZ=Asia/Shanghai

RUN brew update --verbose && \
    brew install ttyd dolphie && \
    echo "🎉 Homebrew 镜像制作成功！"
