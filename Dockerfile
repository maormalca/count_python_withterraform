FROM python
EXPOSE 8081
WORKDIR /maormicroservice 
COPY service.py requirements.txt ./
RUN pip install -r requirements.txt
CMD ["python","service.py"]



