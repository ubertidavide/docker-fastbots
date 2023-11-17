FROM python:3.11

# mantainer
LABEL mantainer="Uberti Daivde <24529587+ubertidavide@users.noreply.github.com>"

# update dependencies
RUN apt-get update && apt-get upgrade -y 

# install firefox
RUN apt install firefox-esr -y

# install poetry
RUN curl -sSL https://install.python-poetry.org | python -

# install python dependencies
COPY pyproject.toml poetry.lock* ./

# Intall only production dependencies
RUN ~/.local/share/pypoetry/venv/bin/poetry install

# add all the project files
COPY . .

# use firefox in headless mode
ENV MOZ_HEADLESS=0

# add execution permission to the script
RUN chmod +x ./entrypoint.sh

# use the cwd as the python path
ENV PYTHONPATH=.

# enntrypoint script
ENTRYPOINT ["./entrypoint.sh"]