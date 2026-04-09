  module m
  implicit none
  contains

  subroutine sub(x, a, b, c, d, e)
  real, intent(in) :: x
  real, intent(out) :: a(2,3), b(:,:), c(2,3), d(2,3), e(2,3)

  if (x > 0) then
  a(1,1) = x
  b(:,1) = x
  c(2,:) = x
  d(:, :) = x
  e(1:2,2:3) = x
  end if

  end subroutine sub

  end module m

  program main
  use m
  implicit none
  real :: x = 10.0
  real :: a(2,3), b(2,3), c(2,3), d(2,3), e(2,3)

  call sub(x, a, b, c, d, e)

  print *, "a =", a
  print *, "b =", b
  print *, "c =", c
  print *, "d =", d
  print *, "e =", e

  end program main
