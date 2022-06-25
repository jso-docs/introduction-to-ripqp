# This file was generated, do not modify it.

using QuadraticModels, LinearAlgebra, SparseMatricesCOO
Q = [6. 2. 1.
     2. 5. 2.
     1. 2. 4.]
c = [-8.; -3; -3]
A = [1. 0. 1.
     0. 2. 1.]
b = [0.; 3]
l = [0.;0;0]
u = [Inf; Inf; Inf]
QM = QuadraticModel(
  c,
  SparseMatrixCOO(tril(Q)),
  A=SparseMatrixCOO(A),
  lcon=b,
  ucon=b,
  lvar=l,
  uvar=u,
  c0=0.,
  name="QM"
)

using RipQP
stats = ripqp(QM)
println(stats)

using QPSReader, QuadraticModels
QM = QuadraticModel(readqps("QAFIRO.SIF"))

stats = ripqp(QM, display = false)

stats = ripqp(QM, history = true)
pddH = stats.solver_specific[:pddH]

stats = ripqp(QM, scaling = false)

stats = ripqp(QM, itol = InputTol(max_iter = 100, ϵ_rb = 1e-4), scaling = false)

w = SystemWrite(write = true, name="test_", kfirst = 4, kgap=3)
stats1 = ripqp(QM, w = w)

using DelimitedFiles, MatrixMarket
K = MatrixMarket.mmread("test_K_iter4.mtx")
rhs_aff = readdlm("test_rhs_iter4_aff.rhs", Float64)[:]
rhs_cc =  readdlm("test_rhs_iter4_cc.rhs", Float64)[:]

stats1.elapsed_time

using TimerOutputs
TimerOutputs.enable_debug_timings(RipQP)
reset_timer!(RipQP.to)
stats = ripqp(QM)
TimerOutputs.complement!(RipQP.to) # print complement of timed sections
show(RipQP.to, sortby = :firstexec)

