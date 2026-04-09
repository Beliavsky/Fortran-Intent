module m
implicit none
contains
subroutine sub(x,y1,y2,z,a,b)
real, intent(in) :: x
real, intent(out) :: y1, y2, z(3), a(:), b(:)
y1 = x
z(1) = x
if (size(a) > 0) a(1) = x
if (size(b) >= 2) b(1:2) = x
end subroutine sub
end module m

program main
use m
implicit none
real :: x = 10.0, y1, y2, z(3), a(4)
real, allocatable :: b(:)
allocate (b(2*3))
call sub(x, y1, y2, z, a, b)
print*,y1,y2
print*,z
print*,"a =", a
print*,"b =", b
end program main
