defmodule TextClient.Player do
    
    alias TextClient.{Mover, Prompter, State, Summary}

    # won, lost, good guess, bad guess, already used, initializing
    def play(%State{tally: %{ game_state: :won, letters: letters }}) do
        exit_with_message("Winner Winner Chicken Dinner! ", letters)
    end
    
    def play(%State{tally: %{ game_state: :lost, letters: letters }}) do
        exit_with_message("BUMMER!!! The computer has slayed you! ", letters)
    end

    def play(game = %State{tally: %{ game_state: :good_guess }}) do
        continue_with_message(game, "That's correct!!!")
    end
    
    def play(game = %State{tally: %{ game_state: :bad_guess }}) do
        continue_with_message(game, "Sorry, but no.")
    end

    def play(game = %State{tally: %{ game_state: :already_used }}) do
        continue_with_message(game, "Hello McFly!! You used that letter!")
    end

    def play(game) do
        continue(game)
    end

    defp continue_with_message(game, message) do
        IO.puts(message)
        continue(game)
    end

    defp continue(game) do
        game
        |> Summary.display()
        |> Prompter.accept_move()
        |> Mover.move()
        |> play()
    end

    defp exit_with_message(msg, letters) do
        IO.puts(["\n", msg, "The word was #{Enum.join(letters)}"])
        exit(:normal)
    end
end