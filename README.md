# Conqueuer

Conqueuer (pronounced like conquer) is a non-persistent Elixir work queue.


### Documentation and Information

The [docs](http://hexdocs.pm/conqueuer/0.5.1/Conqueuer.html) can be found on the
hexdocs website and [further information](https://hex.pm/packages/conqueuer) on the
hex website.


### Installation

Conqueuer can be installed like:

  1. Add test to your list of dependencies in `mix.exs`:

        def deps do
          [{:conqueuer, "~> 0.5.1"}]
        end

  2. Ensure test is started before your application:

        def application do
          [applications: [:conqueuer]]
        end

### Testing

`mix espec`
