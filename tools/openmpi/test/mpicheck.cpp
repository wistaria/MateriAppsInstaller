#include <iostream>
#include <mpi.h>
#ifdef _OPENMP
# include <omp.h>
#endif

int get_max_threads() {
#ifdef _OPENMP
  return omp_get_max_threads();
#else
  return 1;
#endif
}

int main(int argc, char **argv) {
  int num_procs, rank;
  int name_len, num_threads;
  int total_threads = 0;
  char hostname[MPI_MAX_PROCESSOR_NAME];
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &num_procs); 
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  if (rank == 0) {
    MPI_Get_processor_name(hostname, &name_len);
    num_threads = get_max_threads();
    std::cout << "Rank " << 0 << " on " << hostname << " with " << num_threads << " threads\n";
    total_threads += num_threads;
  }
  for (int p = 1; p < num_procs; ++p) {
    if (rank == 0) {
      MPI_Status status;
      MPI_Recv(hostname, MPI_MAX_PROCESSOR_NAME, MPI_CHAR, p, 0, MPI_COMM_WORLD, &status);
      MPI_Recv(&num_threads, 1, MPI_INT, p, 0, MPI_COMM_WORLD, &status);
      std::cout << "Rank " << p << " on " << hostname << " with " << num_threads << " threads\n";
      total_threads += num_threads;
    } else {
      MPI_Get_processor_name(hostname, &name_len);
      num_threads = get_max_threads();
      MPI_Send(hostname, MPI_MAX_PROCESSOR_NAME, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
      MPI_Send(&num_threads, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
    }
  }
  if (rank == 0) {
    std::cout << "Total number of MPI processes = " << num_procs << std::endl;
    std::cout << "Total number of OpenMP threads = " << total_threads << std::endl;
  }
  MPI_Finalize();
  return 0;
}
