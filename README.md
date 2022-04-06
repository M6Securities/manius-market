# Manius Market

More of a portfolio project, I don't really expect this to be used in production. That being said, I'm building it as if it could be, and it should be flexible enough to develop so. Anyone can contribute, I'll be updating the list of issues on the project board as I go.

This also doubles as a place for me to learn TurboJS, so the entire website is designed around that.


### What is Manius Market?

This is an online market place, with a focus on markets instead of products like Amazon. This is probably similar to Shopify, but I've never used it so I have no idea what their tools are like, this is simply what I would like to see in a similar app. But this is not a Shopify clone.

It'll have features such as online ordering, inventory management, maybe a basic CMS system, and more. All payment processing will be done through Stripe, and will take full advantage of their API. I doubt that will change, working with PayPal is a pain.

Currently, this is just a wrapper around Stripe, but I'm hoping to add more features in the future that will set it apart.


### Details

* Domains
  * [maniusmarket.com](https://maniusmarket.com)
  * [manius.market](https://manius.market)

* Ruby version: `3.1.1`, going to try to always keep this at the latest version
* Rails Version: `7.0.0`, will also try to keep this at the latest version

* System dependencies: none yet

* To run sidekiq: `bundle exec sidekiq`

### Database

This runs on [CockroachDB](https://www.cockroachlabs.com/). 

To start a local instance, run the following commands:
```bash
cockroach start \
--insecure \
--store=node1 \
--listen-addr=localhost:26257 \
--http-addr=localhost:8080 \
--join=localhost:26257,localhost:26258,localhost:26259 \
--background

cockroach init --insecure --host=localhost:26257
```
You can find more information about these commands [here](https://www.cockroachlabs.com/docs/stable/start-a-local-cluster.html).

In this mode you can view DB information at [http://localhost:8080/](http://localhost:8080/).

To create the database, run `rake db:create db:migrate db:seed`

### Environment Credentials

There are quite a few environment credentials needed to run the app. 
You can edit them via `EDITOR=nano rails credentials:edit --environment development`

Here's what the current ones needed are:
```yaml
active_record_encryption:
  primary_key: # key
  deterministic_key: # key
  key_derivation_salt: # key

cockroachdb:
  host: free-tier.gcp-us-centrall.cockroachlabs.cloud
  port: 26257
  cluster: # your cluster name. It's the text before .defaultdb
  username: # username
  password: # password
```

### Environment Variables

The only environment variable needed is `MASTER_KEY`, which is used to decrypt the environment credentials.
But there are some you can use for development purposes, and they are set in `config/application.yml`

```yaml
# if set to true it will attempt to connect to a locally running, insecure cockroachdb instance. See above for starting said instance.
local_cockroachdb: true 
```
