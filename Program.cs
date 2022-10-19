using System;
using System.Collections;
using System.Collections.Generic;

public class Program{

    public static void PrintMatrix(double[,] matrix){
        string printValues = "Matriz Q: \n\n";
        for (int i=0; i < 6; i++){
            printValues += "{ ";
            printValues += String.Format("{0:f} {1:f} {2:f} {3:f}", 
                              matrix[i,0], matrix[i,1],matrix[i,2],matrix[i,3]);
            printValues += " }\n";
        }
        Console.WriteLine(printValues);
    }

    public static void PrintPolicy(string[] policy){
        Console.WriteLine("Politica: \n\n" +
                           policy[4] + " "+ "1\n" + 
                           policy[2] + " "+ policy[3] +"\n" +
                           policy[0] + " "+ policy[1]);
    }

    public static double GetBestAction(double [,] qMatrix, int nextState){
        double qBestAction = 0;
        for(int i=0; i < 4; i++){
            double qCurrAction = qMatrix[nextState,i];
            if(qBestAction < qCurrAction){
                qBestAction = qCurrAction;
            }
        }
        return qBestAction;
    } 
    public static string [] GetPolicy(double [,] qMatrix){
        string [] actions_names = new string [] {"UP","DW", "LF", "RG"};
        string [] policy = new string [6];
        for(int i=0; i< 6; i++){
            int currentIndex = -1;
            double currentValue = -100;
            for (int j=0; j<4; j++){
                if(qMatrix[i,j] > currentValue){
                    currentIndex = j;
                    currentValue = qMatrix[i,j];
                }
            }
            policy[i] = actions_names[currentIndex];
        }
        return policy;
    }
    public static void UpdateState(double [,] qMatrix, int state, int nextState, int action, double alpha, double gamma, int[,] rwMatrix){
        double qEstimated = rwMatrix[state,nextState] + gamma * GetBestAction(qMatrix,nextState);
        qMatrix[state,action] = qMatrix[state,action] + alpha*(qEstimated-qMatrix[state,action]);
    }
    public static void RunThroughTrajectory(double[,] qMatrix, int [,] trajectory, double alpha, double gamma,int [,] rwMatrix ){
        for (int i =0; i < trajectory.GetLength(0); i++){
            UpdateState(qMatrix, trajectory[i,0] - 1,trajectory[i,2] - 1,trajectory[i,1] - 1,alpha, gamma, rwMatrix);
        }
    }
    
    public static void Main(string[] args){
        //Inicializa os valores Alfa e Gama com os valores da questão
        double alpha = 0.5;
        double gamma = 1;

        // Cria a Matriz Q e passa o valor 10 (interesse) para o estado 6
        //6 linhas representam os estados e 4 representa as 4 açoes
        double [,] qMatrix = new double[6,4]; 
        for(int i=0; i < 4; i++) {
            qMatrix[5,i] = 10; 
        }

        //Cria a Matriz de Recompensa com os valores estabelecidos pela questão
        //As linhas representam o estado e as colunas são o estado de destino
        //Vendo as Trajetórias, quando seria uma que bate na parede, ela permanece no mesmo estado 
        //Então nesses casos seria o -10
        int [,] rwMatrix = new int[5,6] {
            // 1   2   3   4   5   6
            {-10, -1, -1,  0,  0,  0}, //1
            { -1,-10,  0, -1,  0,  0}, //2
            { -1,  0,-10, -1, -1,  0}, //3
            {  0, -1, -1,-10,  0, 10}, //4
            {  0,  0, -1,  0,-10, 10}  //5
        }; 

        //Trajetórias (1 = UP, 2 = DOWN, 3 = LEFT, 4 = RIGHT)
        int [,] trajectory1 = {{1,1,2},{2,2,2},{2,4,2},{2,3,1},{1,4,3},{3,3,3},{3,3,3},{3,1,5},{5,4,6}};
        int [,] trajectory2 = {{1,1,3},{3,1,5},{5,3,3},{3,3,3},{3,3,5},{5,4,6}};
        int [,] trajectory3 = {{1,2,1},{1,1,3},{3,4,5},{5,1,5},{5,2,5},{5,3,5},{5,2,3},{3,1,5},{5,4,5},{5,4,6}};
        int [,] trajectory4 = {{1,1,3},{3,4,4},{4,1,6}};
        int [,] trajectory5 = {{1,3,1},{1,1,1},{1,1,3},{3,1,5},{5,3,5},{5,2,3},{3,1,5},{5,1,5},{5,1,5},{5,2,3},{3,1,3},{3,3,3},{3,4,4},{4,1,6}};

        //Executando o Q Learning Sequencialmente pelas 5 trajetórias
        RunThroughTrajectory(qMatrix, trajectory1, alpha, gamma, rwMatrix);
        RunThroughTrajectory(qMatrix, trajectory2, alpha, gamma, rwMatrix);
        RunThroughTrajectory(qMatrix, trajectory3, alpha, gamma, rwMatrix);
        RunThroughTrajectory(qMatrix, trajectory4, alpha, gamma, rwMatrix);
        RunThroughTrajectory(qMatrix, trajectory5, alpha, gamma, rwMatrix);
    
        //Imprimindo a Matriz Q resultante das operações e a política
        string [] policy = GetPolicy(qMatrix);
        PrintMatrix(qMatrix);
        PrintPolicy(policy);
    }
}