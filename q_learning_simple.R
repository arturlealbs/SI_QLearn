# MATRIZES DE PROBABILIDADES DE TRANSIÇÃO DE ESTADOS E VETOR DE RECOMPENSAS 

# MATRIZ DE TRANSICAO PARA A ACAO UP

T_up = matrix(0,6,6)  

T_up[1,3] = 0.8
T_up[1,1] = 0.1
T_up[1,2] = 0.1

T_up[2,2] = 0.1
T_up[2,4] = 0.8
T_up[2,1] = 0.1

T_up[3,3] = 0.1
T_up[3,5] = 0.8
T_up[3,4] = 0.1


T_up[4,6] = 0.8
T_up[4,4] = 0.1
T_up[4,3] = 0.1 



# MATRIZ DE TRANSICAO PARA A ACAO DOWN

T_down = matrix(0,6,6) 
T_down[1,1] = 0.9 
T_down[1,2] = 0.1 

T_down[2,2] = 0.9 
T_down[2,1] = 0.1 

T_down[3,1] = 0.8 
T_down[3,3] = 0.1 
T_down[3,4] = 0.1 

T_down[4,2] = 0.8
T_down[4,3] = 0.1 
T_down[4,4] = 0.1 


# MATRIZ DE TRANSICAO PARA A ACAO LEFT

T_left = matrix(0,6,6) 
T_left[1,1] = 0.9
T_left[1,3] = 0.1

T_left[2,1] = 0.8
T_left[2,4] = 0.1
T_left[2,2] = 0.1

T_left[3,3] = 0.8
T_left[3,1] = 0.1
T_left[3,5] = 0.1

T_left[4,3] = 0.8
T_left[4,2] = 0.1
T_left[4,6] = 0.1


# MATRIZ DE TRANSICAO PARA A ACAO RIGHT

T_right = matrix(0,6,6)

T_right[1,3] = 0.1
T_right[1,1] = 0.1
T_right[1,2] = 0.8

T_right[2,2] = 0.9
T_right[2,4] = 0.1

T_right[3,4] = 0.8
T_right[3,1] = 0.1
T_right[3,5] = 0.1

T_right[4,4] = 0.8
T_right[4,6] = 0.1
T_right[4,2] = 0.1

# VETOR DE RECOMPENSA

rw = matrix(-0.04,1,6)
rw[1,5] = -1
rw[1,6] = 1





choose_action <- function(){
# FUNCAO PARA ESCOLHER UMA ACAO DE FORMA ALEATORIA PARA SER EXPLORADA PELO AGENTE
   
   r = sample(4)
   
   return(r[1])
   
} 


calc_action_result <- function(state,transition_state){
# FUNCAO PARA SIMULAR O RESULTADO DE UMA ACAO APLICADA AO ESTADO STATE
# A ENTRADA 'transition_state' ESTA ASSOCIADA A ACAO A SER APLICADA  
   
      
   cand_states = which(transition_state !=0)
   prod_cand_states = transition_state[cand_states] 
 
   aux = sort( prod_cand_states, index.return = TRUE)
   
   cand_states_sort = cand_states[aux$ix]  
   prod_cand_states_sort = aux$x
   
   roleta = cumsum(aux$x)
   
   r = runif(1)
   
   ind = which(roleta > r)
   
   return(cand_states_sort[ind[1]])

   
}

q_update <- function(state,action,next_state,rw,q_matrix,alpha,gamma)
{  
   # FUNCAO PARA ATUALIZAR A UTILIDADE RELACIONADA AO ESTADO STATE E A ACAO ACTION
   
   # DEVE SER LEVANDO EM CONSIDERACAO A RECOMPENSA OBSERVADA NO ESTADO ATUAL, I.E., 
   # E rw[state] E A UTILIDADE ESPERADA DA MELHOR ACAO POSSIVEL NO PROXIMO ESTADO, I.E.,
   # max(q_matrix[next_state,])
  
  estimate_q = rw[state] + gamma * max(q_matrix[next_state,])
    
  # PARA SE CONSIDERAR O HISTORICO DAS ACOES DE EXPLORAÇÃO, SE FAZ UM AJUSTE DA MATRIX
  # Q CONSIDERANDO O VALOR ATUAL q_matrix[state, action] E O DESVIO EM RELAÇÃO A ESTIIMATIVA
  # ACIMA I.E., estimate_q - q_matrix[state, action]
  
  q_value = q_matrix[state, action] + alpha*(estimate_q - q_matrix[state, action])

  return(q_value)

}




actions_names = c("UP","DW","LF","RG")


# inicialização da matriz de q valores
q_matrix = matrix(0,6,4)
q_matrix[5,]=c(-1,-1,-1,-1)
q_matrix[6,]=c(1,1,1,1)

alpha = 0.5
gamma = 1

rw = matrix(-0.04,1,6)
rw[1,5] = -1
rw[1,6] = 1




for(i in 1:200){

# CADA EXECUCAO DO LOOP CORRESPONDE A EXPLORAÇÃO DO AMBIENTE A PARTIR DO ESTADO 
# INICIAL, ESCOLHENDO AÇÕES ALEATORIAMENTE ATE QUE UM ESTADO TERMINADO SEJA ALCANÇADO

state = 1

terminal = TRUE

while(terminal)
{
  
   # ESCOLHER UMA ACAO PARA EXPLORAR O AMBIENTE
   
   action_trial = choose_action()
  
   
   # ESCOLHER A MATRIZ DE TRANSICAO CORRESPONDENDE A ACAO ESCOLHIDA ACIMA
   
   if(action_trial == 1){transition_state = T_up[state,]} 
   if(action_trial == 2){transition_state = T_down[state,]} 
   if(action_trial == 3){transition_state = T_left[state,]} 
   if(action_trial == 4){transition_state = T_right[state,]} 
  
   # APLICAR A ACAO E OBSERVAR O ESTADO ALCANÇADO
   
   next_state = calc_action_result(state,transition_state)
   
   
   print(c(state,actions_names[action_trial],next_state))
   
   # ATUALIZAR A UTILIDADE RELACIONADA AO ESTADO STATE E A ACAO ESCOLHIDA
   
   # DEVE SER LEVANDO EM CONSIDERACAO A RECOMPENSA OBSERVADA NO ESTADO ATUAL E 
   # A MAXIMA UTILIDADE ESPERADA PELA MELHOR ACAO DO PROXIMO ESTADO
   
   q_matrix[state,action_trial] = q_update(state,action_trial,next_state,rw,q_matrix,alpha,gamma)
   
   # ATUq_matrixALIZAR O ESTADO ATUAL
   state = next_state
   
   # TESTE DE PARADA   
  
  
   if(state==5){terminal=FALSE}
   if(state==6){terminal=FALSE}
     
}

print("")

}


# IMPRIMIR A POLITICA RETORNADA

policy = max.col(q_matrix)

actions = actions_names
s1 = paste("-1","+1")
s2 = paste(actions[policy[3]],actions[policy[4]])
s3 = paste(actions[policy[1]],actions[policy[2]])

cat("\n",s1,"\n",s2,"\n",s3)






