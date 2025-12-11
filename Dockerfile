FROM homebrew/ubuntu24.04
# 设置时区为上海时区
USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
# 切换回 linuxbrew 用户
USER linuxbrew
# 设置环境变量
ENV HOMEBREW_NO_AUTO_UPDATE=1
ENV TZ=Asia/Shanghai
# 更新 Homebrew 并安装软件
RUN brew update
RUN brew install ttyd dolphie