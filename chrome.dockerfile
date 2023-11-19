FROM python:3.11

# mantainer
LABEL mantainer="Uberti Davide <24529587+ubertidavide@users.noreply.github.com>"

# update dependencies
RUN apt-get update && apt-get upgrade -y

# install required chrome dependencies
RUN apt install curl software-properties-common apt-transport-https ca-certificates -y

# import gpg keys for chrome
RUN curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/google-chrome.gpg > /dev/null

# import google chrome repositories
RUN echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | tee /etc/apt/sources.list.d/google-chrome.list

# install chrome
RUN apt-get update && apt install google-chrome-stable -y

# install poetry
RUN curl -sSL https://install.python-poetry.org | python -

# install python dependencies
COPY pyproject.toml poetry.lock* ./

# Disable poetry virtualenvs creation
RUN ~/.local/share/pypoetry/venv/bin/poetry config virtualenvs.create false

# Intall only production dependencies
RUN ~/.local/share/pypoetry/venv/bin/poetry install

# add all the project files
COPY . .

# add execution permission to the script
RUN chmod +x ./entrypoint.sh

# use the cwd as the python path
ENV PYTHONPATH=.

# enntrypoint script
ENTRYPOINT ["./entrypoint.sh"]