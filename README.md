lj_rnd_photo
============

Rake task which publishes random photo tagged with some tag to LiveJournal

Run
---

    rake lj_rnd_photo FLICKR_API_KEY=... FLICKR_SECRET=... TAG=... LJ_LOGIN=... LJ_PASSWORD=... LJ_JOURNAL=...

Install to heroku
-----------------

    heroku create
    heroku config:add FLICKR_API_KEY=... FLICKR_SECRET=... TAG=... LJ_LOGIN=... LJ_PASSWORD=... LJ_JOURNAL=...
    git push heroku master

Run:

    heroku run rake lj_rnd_photo

[Scheduler](https://devcenter.heroku.com/articles/scheduler):

    heroku addons:add scheduler:standard
    heroku addons:open scheduler

Add job:

    rake lj_rnd_photo 