# 使用 Python 3.9-slim 作为基础镜像
FROM python:3.9-slim

# 更新系统并安装必需的依赖库
RUN apt-get update && apt-get install -y libpq-dev gcc

# 升级 pip
RUN pip install --upgrade pip

# 设置工作目录
WORKDIR /app

# 复制应用代码到容器中
COPY . /app

# 安装 Python 依赖
RUN pip install --no-cache-dir flask psycopg2-binary

# 暴露应用的端口
EXPOSE 5000

# 启动应用
CMD ["python", "app.py"]
