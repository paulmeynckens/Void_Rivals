using System.Collections;
using System.Collections.Generic;
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

        // Update is called once per frame
        private void FixedUpdate()
        {

            switch (characterMove.CurrentCharacterMode)
            {
                case CharacterMode.walking:
                    animator.SetBool("OnHull", false);
                    animator.SetBool("Fly", !walker.isGrounded && !characterWalk.IsClimbing);

                    break;
                case CharacterMode.magnetic_boots:
                    animator.SetBool("OnHull", true);
                    animator.SetBool("Fly", false);
                    break;

                case CharacterMode.flying:
                    animator.SetBool("OnHull", false);
                    animator.SetBool("Fly", true);
                    break;


            }
            if (characterMove.DisplayedInput != null)
            {
                animator.SetFloat("x", characterMove.DisplayedInput.rightLeft);
                animator.SetFloat("y", characterMove.DisplayedInput.forwardBackward);
            }
        }
    }
}
