FROM python:3.8-slim
WORKDIR /opt/app
copy ./ /opt/app
RUN pip3 install --no-cache-dir -r /opt/app/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ 
ENV PYTHONPATH /opt/app
CMD ["uvicorn",  "main:app", "--host", "0.0.0.0"]% 
