# ========================================================================================
# File: solution.jl
# Brief: Code for solving problems 1, 2, and 3 of the Module 5 Homework
# ========================================================================================

using DataFrames
using CSV

# ----------------------------------------------------------------------------------------
# Filepath utilities
# ----------------------------------------------------------------------------------------
data_dir() = joinpath(dirname(@__DIR__), "data")

# ----------------------------------------------------------------------------------------
# Kepler Error Equation and Associated Derivatives
# ----------------------------------------------------------------------------------------
kepler_error(e, M, E) = E - e * sin(E) - M
kepler_error_d(e, M, E) = 1 - e * cos(E)
kepler_error_dd(e, M, E) = e * sin(E)
kepler_error_ddd(e, M, E) = e * cos(E)

# ----------------------------------------------------------------------------------------
# Update Methodsd
#
#   Currently Implemented:
#       * Simple Iteration
#       * Newton-Raphson
#       * Danby (Murray and Dermott Section 2.4)
# ----------------------------------------------------------------------------------------
iterative_update(e, M, E) = M + e * sin(E)
newton_raphson_update(e, M, E) = E - kepler_error(e, M, E) / kepler_error_d(e, M, E)

function danby_update(e, M, E)
    f = kepler_error(e, M, E)
    fp = kepler_error_d(e, M, E)
    fpp = kepler_error_dd(e, M, E)
    fppp = kepler_error_ddd(e, M, E)

    delta_1 = - f / fp
    delta_2 = - f / (fp + (1//2) * delta_1 * fpp)
    delta_3 = - f / (fp + (1//2) * delta_2 * fpp + (1//6) * delta_2^2 * fppp)

    return E + delta_3
end

# ----------------------------------------------------------------------------------------
# Solve Method
# ----------------------------------------------------------------------------------------
function solve(updater, e, M; tolerance=deg2rad(1e-6), max_iter=Inf)
    E_guess = M

    err_val = kepler_error(e, M, E_guess)

    guesses = [E_guess]
    relative_update = [0-.0] 
    absolute_error = [err_val]

    while abs(err_val) > tolerance && length(guesses) < (max_iter + 1)
        E_last = E_guess
        E_guess = updater(e, M, E_guess)
        err_val = kepler_error(e, M, E_guess)

        push!(guesses, E_guess)
        push!(relative_update, (E_guess - E_last) / E_guess)
        push!(absolute_error, err_val)
    end

    return (guesses, relative_update, absolute_error)
end

# ----------------------------------------------------------------------------------------
# Main Entry Point
# ----------------------------------------------------------------------------------------
function main()
    force = "-f" in ARGS

    tolerance = deg2rad(1e-6)
    e = 0.1
    M = deg2rad(5)

    simulations = Dict(
        "module05-prob01-output.csv" => iterative_update,
        "module05-prob02-output.csv" => newton_raphson_update,
        "module05-prob03-output.csv" => danby_update,
    )

    for (file_name, updater) in simulations
        # Don't overwrite data unless force flag given
        output_path = joinpath(data_dir(), file_name)
        if isfile(output_path) && !force
            @warn "File already found at $(output_path), rerun with -f to overwrite"
            continue
        end

        (E_vals, dE, err) = solve(updater, e, M; tolerance=tolerance)
        output = DataFrame(
            eccentric_anomaly=E_vals, 
            relative_update=dE, 
            absolute_error=err
        )
        CSV.write(output_path, output)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
