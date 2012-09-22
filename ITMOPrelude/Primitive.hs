{-# LANGUAGE NoImplicitPrelude #-}
module ITMOPrelude.Primitive where

import Prelude (Show,Read,error)

---------------------------------------------
-- ��������� ������-���������

-- ������������� �����������
example1 x  = x
example1'   = \x -> x
example1''  = let y = \x -> x in y
example1''' = y where
    y = \x -> x

-- ����� ������������� �����������
example2 x y  = x %+ y
example2' x   = \y -> x %+ y
example2''    = \x -> \y -> x %+ y
example2'''   = \x y -> x %+ y
example2''''  = let z = \x y -> x %+ y in z
example2''''' = z where
    z x = \y -> x %+ y

-- ����������� ���������
undefined = undefined

-- ���� ������� ����������� ��� �����, ��������� �� undefined ��������.
-- ����� ����� ����� ������������ (natEq � natLt --- ������� ���������).

-------------------------------------------
-- ����������� ����

-- ��� � ������������ ���������
data Unit = Unit deriving (Show,Read)

-- ����, ������������
data Pair a b = Pair { fst :: a, snd :: b } deriving (Show,Read)

-- �������, ��������������
data Either a b = Left a | Right b deriving (Show,Read)

-- ������ ������� ������, ��������� Either Unit a
data Maybe a = Nothing | Just a deriving (Show,Read)

-- ������ ������� ������, ��������� Either Unit Unit
data Bool = False | True deriving (Show,Read)

-- ������� ��������, ��� ���������� if � ���� Bool ������������ ������,
-- ���� case ������ ��������.

-- �� ��� ����� ����������� ���� if
if' True a b = a
if' False a b = b

-- ����������. ������������� ���, ������������ ��������� ���������
data Tri = LT | EQ | GT deriving (Show,Read)

-------------------------------------------
-- ������ ��������

-- ���������� "��"
not :: Bool -> Bool
not True = False
not False = True

infixr 3 &&
-- ���������� "�"
(&&) :: Bool -> Bool -> Bool
True  && x = x
False && _ = False

infixr 2 ||
-- ���������� "���"
(||) :: Bool -> Bool -> Bool
True  || _ = True
False || x = x

-------------------------------------------
-- ����������� �����

data Nat = Zero | Succ Nat deriving (Show,Read)

natZero = Zero     -- 0
natOne = Succ Zero -- 1

inverseSucc :: Nat -> Nat
inverseSucc Zero = error "Trying to decrease natural zero!"
inverseSucc (Succ n) = n

-- ���������� ��� ����������� �����
natCmp :: Nat -> Nat -> Tri
natCmp first second = if' (natEq first second) EQ (if' (natLt first second) LT GT)

-- n ��������� � m 
natEq :: Nat -> Nat -> Bool
natEq Zero     Zero     = True
natEq Zero     (Succ _) = False
natEq (Succ _) Zero     = False
natEq (Succ n) (Succ m) = natEq n m

-- n ������ m
natLt :: Nat -> Nat -> Bool
natLt Zero     Zero     = False
natLt Zero     (Succ m) = True
natLt (Succ n) Zero     = False
natLt (Succ n) (Succ m) = natLt n m

infixl 6 +.
-- �������� ��� ����������� �����
(+.) :: Nat -> Nat -> Nat
Zero     +. m = m
(Succ n) +. m = Succ (n +. m)

infixl 6 -.
-- ��������� ��� ����������� �����
(-.) :: Nat -> Nat -> Nat
(Succ n) -. m = case compare of LT -> error "Trying to deduct greater natural value from smaller"
                                EQ -> Zero
                                GT -> Succ (n -. m)
                    where compare = natCmp (Succ n) m

infixl 7 *.
-- ��������� ��� ����������� �����
(*.) :: Nat -> Nat -> Nat
Zero     *. m = Zero
(Succ n) *. m = m +. (n *. m)

-- ����� � ������� �� ������� n �� m
natDivMod :: Nat -> Nat -> Pair Nat Nat
natDivMod n m = case compare of LT -> Pair Zero n
                                EQ -> Pair (Succ Zero) Zero
                                GT -> Pair (Succ (fst (natDivMod (n -. m) m))) (snd (natDivMod (n -. m) m))
                    where compare = natCmp n m

natDiv n = fst . natDivMod n -- �����
natMod n = snd . natDivMod n -- �������

-- ����� GCD ���������� ������� (������ �������� 2 (���������������� �����) + 1 (���) �������)
gcd :: Nat -> Nat -> Nat
gcd a Zero = a
gcd a b = gcd b (natMod a b)

-------------------------------------------
-- ����� �����

-- ���������, ����� ������������� ������� ����� ���� ������������
data Int = Negative Nat | IntZero | Positive Nat deriving (Show,Read)

intZero   = IntZero   -- 0
intOne    = Positive Zero    -- 1
intNegOne = Negative Zero -- -1

-- n -> - n
intNeg :: Int -> Int
intNeg (Negative n) = (Positive n)
intNeg IntZero = IntZero
intNeg (Positive n) = (Negative n)

-- ������ ����� ��� ��� �����������
intCmp :: Int -> Int -> Tri
intCmp (Negative n) (Negative m) = natCmp m n
intCmp (Negative n) _ = LT
intCmp IntZero (Negative n) = GT
intCmp IntZero IntZero = EQ
intCmp IntZero (Positive n) = LT
intCmp (Positive n) (Positive m) = natCmp n m
intCmp (Positive n) _ = GT

intEq :: Int -> Int -> Bool
intEq n m = case (intCmp n m) of LT -> False
                                 EQ -> True
                                 GT -> False

intLt :: Int -> Int -> Bool
intLt n m = case (intCmp n m) of LT -> True
                                 EQ -> False
                                 GT -> False

infixl 6 .+., .-.
-- � ���� ��� ������������ �������� ���� �� ��� �����
(.+.) :: Int -> Int -> Int
n .+. IntZero = n
IntZero .+. m = m
(Negative n) .+. (Negative m) = Negative (n +. m +. Succ (Zero))
(Negative n) .+. (Positive m) = case compare of LT -> (Positive (m -. n))
                                                EQ -> IntZero
                                                GT -> (Negative (n -. m))
                                    where compare = natCmp n m
(Positive m) .+. (Negative n) = case compare of LT -> (Positive (m -. n))
                                                EQ -> IntZero
                                                GT -> (Negative (n -. m))
                                    where compare = natCmp n m
(Positive n) .+. (Positive m) = Positive (n +. m +. Succ (Zero))

(.-.) :: Int -> Int -> Int
n .-. m = n .+. (intNeg m)

infixl 7 .*.
(.*.) :: Int -> Int -> Int
n .*. IntZero = IntZero
IntZero .*. m = IntZero
--(Negative n) .*. (Negative m) = Positive $ inversedSucc $ (Succ n) *. (Succ m)
--(Negative n) .*. (Positive m) = Negative $ inversedSucc $ (Succ n) *. (Succ m)
--(Positive m) .*. (Negative n) = Negative $ inversedSucc $ (Succ n) *. (Succ m)
--(Positive n) .*. (Positive m) = Positive $ inversedSucc $ (Succ n) *. (Succ m)
(Negative n) .*. (Negative m) = Positive $ product
    where (Succ product) = (Succ n) *. (Succ m)
(Negative n) .*. (Positive m) = Negative $ product
    where (Succ product) = (Succ n) *. (Succ m)
(Positive m) .*. (Negative n) = Negative $ product
    where (Succ product) = (Succ n) *. (Succ m)
(Positive n) .*. (Positive m) = Positive $ product
    where (Succ product) = (Succ n) *. (Succ m) --I'm not sure if this works


-------------------------------------------
-- ������������ �����

data Rat = Rat Int Nat

ratNeg :: Rat -> Rat
ratNeg (Rat x y) = Rat (intNeg x) y

-- � ������������ ��� ���� �������� ��������
ratInv :: Rat -> Rat
ratInv (Rat (Negative n) (Succ m)) = (Rat (Negative m) (Succ n))
ratInv (Rat IntZero _) = error "Trying to get inversed from zero"
ratInv (Rat (Positive n) (Succ m)) = (Rat (Positive m) (Succ n))

-- ������ ��� ������
ratCmp :: Rat -> Rat -> Tri
ratCmp (Rat n1 (Succ m1)) (Rat n2 (Succ m2)) = intCmp (n1 .*. (Positive m2)) (n2 .*. (Positive m1))

ratEq :: Rat -> Rat -> Bool
ratEq n m = case (ratCmp n m) of LT -> False
                                 EQ -> True
                                 GT -> False

ratLt :: Rat -> Rat -> Bool
ratLt n m = case (ratCmp n m) of LT -> True
                                 EQ -> False
                                 GT -> False

infixl 7 %+, %-
(%+) :: Rat -> Rat -> Rat
(Rat n1 (Succ m1)) %+ (Rat n2 (Succ m2)) = Rat ((n1 .*. (Positive m2)) .+. (n2 .*. (Positive m1))) ((Succ m1) *. (Succ m2))

(%-) :: Rat -> Rat -> Rat
n %- m = n %+ (ratNeg m)

infixl 7 %*, %/
(%*) :: Rat -> Rat -> Rat
(Rat n1 (Succ m1)) %* (Rat n2 (Succ m2)) = Rat (n1 .*. n2) ((Succ m1) *. (Succ m2))

(%/) :: Rat -> Rat -> Rat
n %/ m = n %* (ratInv m)

-------------------------------------------
-- �������� ��� ���������.
-- ���������� �����, �� ������������ ����� � ����

infixr 9 .
f . g = \ x -> f (g x)

infixr 0 $
f $ x = f x

-- ������������� �����������
example3   a b c = gcd a (gcd b c)
example3'  a b c = gcd a $ gcd b c
example3'' a b c = ($) (gcd a) (gcd b c)

-- � ��� ������������� �����������
example4  a b x = (gcd a (gcd b x))
example4' a b = gcd a . gcd b