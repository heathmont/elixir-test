defmodule ExBanking do
  @moduledoc """
  ExBanking simple banking OTP application.
  """
  use Application
  alias ExBanking.Registry

  @typedoc """
  Defining custom type for functions with error result
  """
  @type banking_error ::
          {:error,
           :wrong_arguments
           | :user_already_exists
           | :user_does_not_exist
           | :not_enough_money
           | :sender_does_not_exist
           | :receiver_does_not_exist
           | :too_many_requests_to_user
           | :too_many_requests_to_sender
           | :too_many_requests_to_receiver}

  @name ExBanking.Registry

  @impl true
  def start(_type, _args) do
    ExBanking.Supervisor.start_link([])
  end

  @spec create_user(user :: String.t()) :: :ok | banking_error
  def create_user(user) do
    if not is_binary(user) do
      {:error, :wrong_arguments}
    end

    Registry.create(@name, user)
  end

  @spec deposit(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | banking_error
  def deposit(user, amount, currency) do
    if not is_number(amount) or amount < 0 do
      {:error, :wrong_arguments}
    else
      Registry.deposit(@name, user, amount / 1, currency)
    end
  end

  @spec withdraw(user :: String.t(), amount :: number, currency :: String.t()) ::
          {:ok, new_balance :: number} | banking_error
  def withdraw(user, amount, currency) do
    if not is_number(amount) or amount < 0 do
      {:error, :wrong_arguments}
    else
      Registry.withdraw(@name, user, amount, currency)
    end
  end

  @spec get_balance(user :: String.t(), currency :: String.t()) ::
          {:ok, balance :: number} | banking_error
  def get_balance(user, currency) do
    Registry.get_balance(@name, user, currency)
  end

  @spec send(
          from_user :: String.t(),
          to_user :: String.t(),
          amount :: number,
          currency :: String.t()
        ) :: {:ok, from_user_balance :: number, to_user_balance :: number} | banking_error
  def send(from_user, to_user, amount, currency) do
    if not is_number(amount) or amount < 0 do
      {:error, :wrong_arguments}
    else
      Registry.send(@name, from_user, to_user, amount / 1, currency)
    end
  end
end
