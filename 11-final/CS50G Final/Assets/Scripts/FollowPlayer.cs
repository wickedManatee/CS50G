using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowPlayer : MonoBehaviour
{
    GameObject player;
    public float speed;

    float distance;
    Vector3 playerPrevPos, playerMoveDir, offset;
    void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        playerPrevPos = player.transform.position;

        offset = transform.position - player.transform.position;
        distance = offset.magnitude;
    }

    // Update is called once per frame
    void LateUpdate()
    {
        playerMoveDir = player.transform.position - playerPrevPos;
        if (playerMoveDir != Vector3.zero)
        {
            playerMoveDir.Normalize();
            transform.position = player.transform.position - playerMoveDir * distance + new Vector3(0,3,0);

            transform.LookAt(player.transform.position);
            playerPrevPos = player.transform.position;
        }
    }
}
