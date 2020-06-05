using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Despawner : MonoBehaviour
{
    public GameObject[] destroyMe;

    // Update is called once per frame
    void Update()
    {
        if (transform.position.y < -2)
        {
            if (gameObject.tag == "Player")
            {
                foreach (GameObject go in destroyMe)
                {
                    Destroy(go);
                }
                PointTracker.ResetScore();
                UnityEngine.SceneManagement.SceneManager.LoadScene("GameOver");
            }
                
        }
    }
}
