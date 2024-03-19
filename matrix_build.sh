# Define your matrices
python_versions=("3.8" "3.9" "3.10" "3.11")
numpy_versions=("1.19" "1.20" "1.21" "1.22" "1.23" "1.24" "1.25" "1.26")
mpi_types=("openmpi" "mpich")
openmpi_versions=("4.1.2" "4.1.3" "4.1.4" "4.1.5" "4.1.6" "5.0.0" "5.0.1")
mpich_versions=("4.0.2" "4.0.3" "4.1.2" "4.2.0" "5.0.1")
results_file="build_results.txt"

# Loop over each configuration
for py in "${python_versions[@]}"; do
  for np in "${numpy_versions[@]}"; do
    for mpi in "${mpi_types[@]}"; do
      if [ "$mpi" == "openmpi" ]; then
        for mpi_version in "${openmpi_versions[@]}"; do
          echo "Building for Python $py, NumPy $np, MPI $mpi $mpi_version"
          if conda build recipe --variants="{mpi: '$mpi', mpi_ver: '$mpi_version', python: '$py', numpy: '$np'}" -c tomsail; then
            echo "SUCCESS: Python $py, NumPy $np, MPI $mpi $mpi_version" >> "$results_file"
          else
            echo "FAIL: Python $py, NumPy $np, MPI $mpi $mpi_version" >> "$results_file"
          fi
        done
      elif [ "$mpi" == "mpich" ]; then
        for mpi_version in "${mpich_versions[@]}"; do
          echo "Building for Python $py, NumPy $np, MPI $mpi $mpi_version"
          if conda build recipe --variants="{mpi: '$mpi', mpi_ver: '$mpi_version', python: '$py', numpy: '$np'}" -c tomsail; then
            echo "SUCCESS: Python $py, NumPy $np, MPI $mpi $mpi_version" >> "$results_file"
          else
            echo "FAIL: Python $py, NumPy $np, MPI $mpi $mpi_version" >> "$results_file"
          fi
        done
      fi
    done
  done
done
