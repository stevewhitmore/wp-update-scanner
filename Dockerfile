FROM python:3.10.3-bullseye

WORKDIR /app

COPY . .
RUN python -m pip install selenium

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable

# Install Chromedriver
RUN apt-get install -yqq unzip  && \
    wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip  && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# Set display port to avoid crash
ENV DISPLAY=:99

# Install Cron
RUN apt-get install -y cron vim mutt && \
    mv /app/.muttrc /root

# Set timezone
ENV TZ="America/Chicago"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN crontab -l | { cat; echo '0 0 * * * cd /app/src && ./run.sh'; } | crontab -

CMD cron && tail -f /dev/null
