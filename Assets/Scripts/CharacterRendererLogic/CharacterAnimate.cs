using System.Collections;
using System.Collections.Generic;
using Mirror;
using UnityEngine;
using CharacterLogic;

namespace CharacterRenderer
{
    [DefaultExecutionOrder(+10)]
    public class CharacterAnimate : MonoBehaviour
    {
        Animator animator;
        CharacterController walker;
        CharacterMove characterMove;
        CharacterWalk characterWalk;
        // Start is called before the first frame update

        private void Awake()
        {
            characterMove = GetComponentInParent<CharacterMove>();
            walker = GetComponentInParent<CharacterController>();
            characterWalk = GetComponentInParent<CharacterWalk>();
            animator = GetComponent<Animator>();
        }

        
        private void FixedUpdate()
        {
            if (characterMove.transform.parent != null)
            {
                switch (characterMove.transform.parent.tag)
                {
                    case "Ship Interior":
                        animator.SetBool("OnHull", false);
                        animator.SetBool("Fly", !walker.isGrounded && !characterWalk.IsClimbing);
                        animator.SetBool("Sit", false);
                        break;

                    case "Ship Hull":
                        animator.SetBool("OnHull", true);
                        animator.SetBool("Fly", false);
                        animator.SetBool("Sit", false);
                        break;

                    case "Seat":
                        animator.SetBool("OnHull", false);
                        animator.SetBool("Fly", false);
                        animator.SetBool("Sit", true);
                        break;

                    default:
                        break;
                }
            }
            else
            {
                animator.SetBool("OnHull", false);
                animator.SetBool("Fly", true);
                animator.SetBool("Sit", false);
            }
            
            if (characterMove.DisplayedInput != null)
            {
                animator.SetFloat("x", characterMove.DisplayedInput.rightLeft);
                animator.SetFloat("y", characterMove.DisplayedInput.forwardBackward);
            }
        }
    }
}
