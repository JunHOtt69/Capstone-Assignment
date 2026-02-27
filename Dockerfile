# 1. Use an official Python runtime as a parent image
FROM python:3.13

# 2. Set environment variables to ensure output is sent to terminal
ENV PYTHONUNBUFFERED=1

# 3. Create a directory for your code inside the container
WORKDIR /app

# 4. Copy your requirements file and install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your project files into the container
COPY . /app/

# 6. Expose the port Django runs on
EXPOSE 8000