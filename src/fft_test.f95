subroutine square_cube(i, isquare, icube)
    use, intrinsic :: iso_c_binding
    implicit none
    include 'fftw3.f03'
    integer, intent (in)  :: i              ! input
    integer, intent (out) :: isquare, icube ! output

    isquare = i**2
    icube   = i**3
end subroutine


