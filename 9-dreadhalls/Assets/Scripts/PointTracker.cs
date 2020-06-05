using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PointTracker : MonoBehaviour
{
    public static int score;
    
    // Start is called before the first frame update
    void Start()
    {
        score = 0;
    }

    public static void IncreaseScore()
    {
        score++;
    }

    public static void ResetScore()
    {
        score = 0;
    }

    public static int GetScore()
    {
        return score;
    }
}
